import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 모양을 세밀하게 조절하기 위한 변수들 (수치를 자유롭게 변경해 보세요)
    final double flareWidth = 20.0;  // 양옆 밑단이 바깥으로 퍼지는 너비
    final double flareHeight = 20.0; // 양옆 밑단 곡선의 높이
    final double topRadius = 15.0;   // 윗부분 양쪽 모서리의 둥글기(반지름)

    // 1. 왼쪽 아래 끝점 (시작)
    path.moveTo(0, size.height);

    // 2. 왼쪽 아래 오목한 곡선 (바깥으로 퍼지는 부분)
    path.quadraticBezierTo(
      flareWidth, size.height,                 // 제어점: 꺾이는 지점
      flareWidth, size.height - flareHeight,   // 끝점: 곡선이 끝나는 위쪽 지점
    );

    // 3. 왼쪽 직선 (위로 쭉 올라감)
    path.lineTo(flareWidth, topRadius);

    // 4. 왼쪽 위 둥근 모서리
    path.quadraticBezierTo(
      flareWidth, 0,                           // 제어점: 왼쪽 위 꼭짓점
      flareWidth + topRadius, 0,               // 끝점
    );

    // 5. 상단 직선 (오른쪽으로 쭉 이동)
    path.lineTo(size.width - flareWidth - topRadius, 0);

    // 6. 오른쪽 위 둥근 모서리
    path.quadraticBezierTo(
      size.width - flareWidth, 0,              // 제어점: 오른쪽 위 꼭짓점
      size.width - flareWidth, topRadius,      // 끝점
    );

    // 7. 오른쪽 직선 (아래로 쭉 내려옴)
    path.lineTo(size.width - flareWidth, size.height - flareHeight);

    // 8. 오른쪽 아래 오목한 곡선 (바깥으로 퍼지는 부분)
    path.quadraticBezierTo(
      size.width - flareWidth, size.height,    // 제어점: 꺾이는 지점
      size.width, size.height,                 // 끝점: 오른쪽 아래 끝
    );

    // 9. 하단 직선 (시작점으로 돌아가며 닫힘)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}