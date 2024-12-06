import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../bloc/vlogs_bloc/vlogs_bloc.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../widgets/single_vlog_widget.dart';

class SingleVlogPage extends StatefulWidget {
  final int vlogId;
  const SingleVlogPage({super.key, required this.vlogId});

  @override
  State<SingleVlogPage> createState() => _SingleVlogPageState();
}

class _SingleVlogPageState extends State<SingleVlogPage> {
  @override
  void initState() {
    super.initState();
    _getVlogDetails();
  }

  _getVlogDetails() {
    context.read<VlogsBloc>().add(FetchSingleVlogEvent(vlogId: widget.vlogId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VlogsBloc, VlogsState>(
        builder: (context, state) {
          if (state.currentVlog?.id == widget.vlogId) {
            return SingleVlogWidget(vlog: state.currentVlog!);
          } else if (state is VlogsErrorState) {
            return MyErrorWidget(
                message: state.message, onRetry: _getVlogDetails);
          } else if (state is VlogsNoInternetConnectionState) {
            return NoInternetConnectionWidget(onRetry: _getVlogDetails);
          }
          return const Center(child: LogoLoader());
        },
      ),
    );
  }
}
