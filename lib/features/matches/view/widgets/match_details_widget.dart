import 'package:auth_api_dopave_app/features/matches/controller/match_details_controller.dart';
import 'package:auth_api_dopave_app/features/matches/model/match_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchDetailsWidget extends StatelessWidget {
  final String matchId;

  const MatchDetailsWidget({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final MatchDetailsController controller = Get.put(
      MatchDetailsController(matchId: matchId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.match.value?.leagueName ?? 'تفاصيل المباراة',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.getMatchDetails(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final match = controller.match.value;
        if (match == null) {
          return const Center(child: Text('لا توجد بيانات للمباراة'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              _buildMatchHeader(match),
              const SizedBox(height: 20),
              _buildStatusCard(match),
              const SizedBox(height: 20),
              _buildInfoCard(match),
              const SizedBox(height: 20),
              _buildTeamsSection(match),
              const SizedBox(height: 20),
              _buildGoalsSection(match),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMatchHeader(MatchInfoModel match) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTeamColumn(match.teamOne, true),
            _buildMatchCenter(match),
            _buildTeamColumn(match.teamTwo, false),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(Team team, bool isHome) {
    return Expanded(
      child: Column(
        children: [
          Image.network(
            team.image,
            width: 80,
            height: 80,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.sports_soccer, size: 60),
          ),
          const SizedBox(height: 8),
          Text(
            team.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            team.score,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCenter(MatchInfoModel match) {
    return Column(
      children: [
        Text(
          match.matchStatus.status.toUpperCase(),
          style: TextStyle(
            color: _getStatusColor(match.matchStatus.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('VS', style: TextStyle(fontSize: 20)),
        if (match.matchStatus.time.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(match.matchStatus.time),
          ),
      ],
    );
  }

  Widget _buildStatusCard(MatchInfoModel match) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'حالة المباراة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(match.matchStatus.fullStatus),
            if (match.matchStatus.time.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('الوقت: ${match.matchStatus.time}'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(MatchInfoModel match) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              'معلومات المباراة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('الملعب', match.matchInfo.stadium),
            _buildInfoRow('التاريخ', _formatDate(match.matchInfo.date)),
            _buildInfoRow('القناة الناقلة', match.matchInfo.channel),
            _buildInfoRow('المعلق', match.matchInfo.commentator),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsSection(MatchInfoModel match) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              'الفرق',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildTeamDetails(match.teamOne, 'الفريق الأول'),
            const SizedBox(height: 16),
            _buildTeamDetails(match.teamTwo, 'الفريق الثاني'),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamDetails(Team team, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildInfoRow('المدرب', team.coach),
        if (team.goals.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('الأهداف', style: TextStyle(fontWeight: FontWeight.bold)),
          ...team.goals.map(
            (goal) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${goal.scorer} (${goal.minute})'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalsSection(MatchInfoModel match) {
    final allGoals = [...match.teamOne.goals, ...match.teamTwo.goals];
    if (allGoals.isEmpty) return const SizedBox();

    // Safe sorting that handles non-numeric minutes
    allGoals.sort((a, b) {
      try {
        final minuteA =
            int.tryParse(a.minute.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final minuteB =
            int.tryParse(b.minute.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return minuteA.compareTo(minuteB);
      } catch (e) {
        return 0; // If parsing fails, maintain original order
      }
    });

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ملخص الأهداف',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...allGoals.map(
              (goal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${goal.minute}\'',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(goal.scorer)),
                    Icon(
                      match.teamOne.goals.contains(goal)
                          ? Icons.sports_soccer
                          : Icons.sports,
                      color:
                          match.teamOne.goals.contains(goal)
                              ? Colors.blue
                              : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
