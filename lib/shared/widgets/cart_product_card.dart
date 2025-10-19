import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/widgets/quantity_selector.dart';
import 'package:flutter/material.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({
    super.key,
    required this.item,
    this.onRemove,
    this.isFromCheckout = false,
  });
  final CartItem item;
  final bool isFromCheckout;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            if (!isFromCheckout)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item.product.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (isFromCheckout) ...[
                    Row(
                      children: [
                        Text(
                          'Quantity: ${item.quantity}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Spacer(),
                        Text(
                          '\$${item.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '\$${item.product.discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            if (!isFromCheckout) ...[
              SizedBox(width: 4),
              QuantitySelector(item: item),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove,
              ),
            ] else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
