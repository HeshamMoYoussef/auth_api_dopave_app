import 'package:auth_api_dopave_app/features/home/controller/home_controller.dart';
import 'package:auth_api_dopave_app/features/matches/controller/matches_controller.dart';
import 'package:auth_api_dopave_app/features/matches/model/matches_model.dart';
import 'package:auth_api_dopave_app/features/matches/view/widgets/match_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchesScreen extends GetView<MatchesController> {
  MatchesScreen({super.key});

  final MatchesController _matchesController = Get.find<MatchesController>();
  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(flex: 2),
              Text(
                'مباريات يوم  ${_formatDate(_selectedDate.value)}',
                style: const TextStyle(fontSize: 18),
              ),
              Spacer(flex: 1),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
                tooltip: 'اختر تاريخ',
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            if (_matchesController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_matchesController.errorMessage.value.isNotEmpty) {
              _matchesController.getMatches(_formatDate(_selectedDate.value));
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_matchesController.errorMessage.value),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => _matchesController.getMatches(
                            _formatDate(_selectedDate.value),
                          ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (_matchesController.matchesList.isEmpty) {
              return const Center(child: Text('لا توجد مباريات متاحة'));
            }

            return RefreshIndicator(
              onRefresh: () => _matchesController.refreshMatches(),
              child: ListView.builder(
                itemCount: _matchesController.matchesList.length,
                itemBuilder: (context, index) {
                  final league = _matchesController.matchesList[index];
                  return _buildLeagueCard(context, league);
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Widget _buildLeagueCard(BuildContext context, MatchesModel league) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              league.leagueName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...league.matches.map((match) => _buildMatchTile(context, match)),
        ],
      ),
    );
  }

  Widget _buildMatchTile(BuildContext context, Match match) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: SizedBox(
        width: MediaQuery.of(context).size.width * 0.145,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                match.teamOne.image,
                width: 40,
                height: 40,
                errorBuilder:
                    (context, error, errorStackTrace) =>
                        const Icon(Icons.sports_soccer),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(match.teamOne.score, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      title: Column(
        children: [
          Text(
            match.status,
            style: TextStyle(
              color: _getStatusColor(match.status),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(match.info.datetime, style: const TextStyle(fontSize: 14)),
          Text(
            '${match.info.stadium} \n ${match.info.channel}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.145,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(match.teamTwo.score, style: const TextStyle(fontSize: 16)),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: Image.network(
                match.teamTwo.image,
                width: 40,
                height: 40,
                errorBuilder:
                    (context, error, errorStackTrace) =>
                        const Icon(Icons.sports_soccer),
              ),
            ),
          ],
        ),
      ),
      onTap: () => Get.to(() => MatchDetailsWidget(matchId: match.matchId)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'مباشر':
        return Colors.red;
      case 'انتهت':
        return Colors.green;
      case 'لم تبدأ':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      helpText: 'اختر تاريخ المباريات',
    );

    if (picked != null && picked != _selectedDate.value) {
      _selectedDate.value = picked;
      _matchesController.changeDate(picked);
    }
  }
}
