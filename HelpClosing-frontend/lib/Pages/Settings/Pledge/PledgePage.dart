import 'package:flutter/material.dart';

class PledgePage extends StatelessWidget {
  const PledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    String pledgeText=''
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur egestas sit amet nibh vitae porttitor. '
        'Etiam non lorem non sem ullamcorper rutrum. Nullam nec pharetra purus. Interdum et malesuada fames ac ante ipsum primis in faucibus.'
        ' Quisque eros velit, sollicitudin nec leo eget, blandit elementum ante. In turpis ipsum, scelerisque a eros sit amet, congue pharetra elit. '
        'Donec sit amet quam nec turpis sodales mattis. Praesent diam tortor, pulvinar vel nisi et, sagittis gravida elit. '
        'Phasellus tincidunt commodo nunc, sed ultricies purus dictum in. Interdum et malesuada fames ac ante ipsum primis in faucibus. '
        'Cras et varius libero. Vivamus ac consectetur ligula. Sed imperdiet ex sit amet enim interdum cursus. Phasellus lobortis placerat justo, '
        'in fringilla nisl hendrerit sit amet. Morbi vitae leo orci. Cras iaculis facilisis arcu quis pharetra. Praesent dignissim bibendum blandit. '
        'Duis odio turpis, malesuada sed condimentum et, congue vitae felis. Nullam consequat nec sapien vel iaculis. Praesent enim risus, feugiat in sapien vitae, luctus sodales enim. In laoreet leo urna, id venenatis odio convallis eu. Cras egestas elit id libero vehicula fermentum. Donec rhoncus dignissim risus. Donec et sem a mi faucibus sollicitudin. Morbi ac ex vitae tellus dictum placerat. Donec vitae dolor vitae nulla pulvinar pretium eget ac nunc. Maecenas sollicitudin venenatis nunc sit amet faucibus. Quisque sed diam et augue vestibulum pulvinar. Maecenas id imperdiet eros. Aenean vulputate congue vehicula. Aenean eget leo ac ex congue bibendum. Nulla pharetra elementum scelerisque. Vivamus mollis, tellus quis mattis suscipit, tortor neque facilisis nunc, vitae tincidunt enim enim in ipsum. Vivamus mi dui, ullamcorper feugiat purus id, vestibulum porta mauris. Aenean scelerisque lobortis purus, a tempor arcu imperdiet nec. Aenean convallis ac dui nec consectetur. Sed imperdiet placerat arcu, sit amet lobortis nunc. '
        'Donec ac felis posuere, maximus nibh ac, fringilla nisi.';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("계약서"),
        titleTextStyle: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blue),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Text(
              pledgeText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }
}
