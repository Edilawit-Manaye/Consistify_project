// consistify_frontend/lib/presentation/pages/dashboard/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:consistify/core/constants/app_constants.dart';
import 'package:consistify/domain/entities/consistency.dart';

import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/blocs/consistency/consistency_bloc.dart';
import 'package:consistify/presentation/widgets/loading_indicator.dart';
import 'package:consistify/presentation/widgets/platform_icon.dart';
import 'package:consistify/presentation/pages/profile/profile_page.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    
    BlocProvider.of<ConsistencyBloc>(context).add(LoadConsistencyData());
    
    _fetchHistoryForCurrentMonth();
  }

  void _fetchHistoryForCurrentMonth() {
    final now = DateTime.now();
    
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0); // Last day of current month
    BlocProvider.of<ConsistencyBloc>(context).add(
      FetchConsistencyHistory(startDate: startDate, endDate: endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Text('Welcome, ${state.user.username}');
            }
            return const Text('Dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<AuthBloc>(context),
                    child: const ProfilePage(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<ConsistencyBloc, ConsistencyState>(
        listener: (context, state) {
          if (state is ConsistencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, consistencyState) {
          // if (consistencyState is ConsistencyLoading && consistencyState.dailyConsistency == null && consistencyState.streakInfo == null) {
          //   return const LoadingIndicator();
          // }
          if (consistencyState is ConsistencyLoading) {
            return const LoadingIndicator();
          }

          DailyConsistency? dailyConsistency;
          StreakInfo? streakInfo;
          List<DailyConsistency> consistencyHistory = [];

          if (consistencyState is ConsistencyLoaded) {
            dailyConsistency = consistencyState.dailyConsistency;
            streakInfo = consistencyState.streakInfo;
            consistencyHistory = consistencyState.consistencyHistory ?? [];
          }

          
          bool isDayConsistent(DateTime day) {
            return consistencyHistory.any((c) =>
            c.date.year == day.year &&
                c.date.month == day.month &&
                c.date.day == day.day &&
                c.overallConsistent);
          }

          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<ConsistencyBloc>(context).add(LoadConsistencyData());
              _fetchHistoryForCurrentMonth();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), 
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildStreaksCard(streakInfo),
                  const SizedBox(height: 20),
                  _buildDailyProgressCard(dailyConsistency),
                  const SizedBox(height: 20),
                  _buildCalendar(consistencyHistory, isDayConsistent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreaksCard(StreakInfo? streakInfo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Streaks 🔥',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStreakItem(
                  'Current Streak',
                  streakInfo?.currentStreak ?? 0,
                  Icons.local_fire_department,
                  Colors.orange,
                ),
                _buildStreakItem(
                  'Longest Streak',
                  streakInfo?.longestStreak ?? 0,
                  Icons.star,
                  Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakItem(String title, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          '$count days',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDailyProgressCard(DailyConsistency? dailyConsistency) {
    final bool overallConsistent = dailyConsistency?.overallConsistent ?? false;
    final List<PlatformActivity> activities = dailyConsistency?.platformActivities ?? [];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Progress (${DateFormat('MMM dd, yyyy').format(DateTime.now())})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  overallConsistent ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: overallConsistent ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  overallConsistent ? 'Consistent Today!' : 'Not Yet Consistent Today',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: overallConsistent ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Platform Details:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            activities.isEmpty
                ? const Text('No platform activity recorded yet or no platforms linked.')
                : Column(
              children: activities.map((activity) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      PlatformIcon(platformName: activity.platform),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppConstants.platformDisplayNames[activity.platform] ?? activity.platform,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Icon(
                        activity.isConsistent ? Icons.check_circle : Icons.circle_outlined,
                        color: activity.isConsistent ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        activity.isConsistent ? 'Solved' : 'Not Solved',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: activity.isConsistent ? Colors.green : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(List<DailyConsistency> consistencyHistory, Function(DateTime) isDayConsistent) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consistency Calendar',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                
                _fetchHistoryForCurrentMonth();
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              calendarStyle: CalendarStyle(
               
                markerSize: 0,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (isDayConsistent(day)) {
                    return Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7), 
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  return null; 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}