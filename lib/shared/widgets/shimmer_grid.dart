import 'package:e_commerce/shared/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';

class ProductShimmerGrid extends StatelessWidget {
  final int itemCount;

  const ProductShimmerGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.636,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerEffect(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ShimmerEffect(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ShimmerEffect(
                  width: 100,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    ShimmerEffect(
                      width: 60,
                      height: 18,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    Spacer(),
                    ShimmerEffect(
                      width: 60,
                      height: 18,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ShimmerEffect(
                width: double.infinity,
                height: 40,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
