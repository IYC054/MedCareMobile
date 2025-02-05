import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key, required this.title});
  final String title;

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue, 
                borderRadius: BorderRadius.circular(
                    8.0), 
              
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(8.0), 
                child: Text(
                  'Danh sách câu hỏi',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                  ),
                ),
              ),
            ),
          ),
          ExpansionTile(
            title: const Text(
              "Vấn đề chung",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            children: [
              ListTile(
                title: const Text(
                  "1. Lợi ích khi sử dụng ứng dụng đăng ký khám bệnh trực tuyến này là gì?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Ứng dụng giúp bạn tiết kiệm thời gian, dễ dàng đăng ký khám bệnh trực tuyến, lựa chọn bác sĩ và thời gian khám phù hợp.",
                ),
              ),
              ListTile(
                title: const Text(
                  "2. Làm sao để sử dụng được ứng dụng đăng ký khám bệnh trực tuyến?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn chỉ cần tải ứng dụng và đăng nhập để bắt đầu sử dụng. Sau đó, chọn bác sĩ và thời gian khám mong muốn.",
                ),
              ),
              ListTile(
                title: const Text(
                  "3. Đăng ký khám bệnh online có mất phí không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Việc đăng ký khám bệnh online không mất phí, tuy nhiên, phí khám có thể thay đổi tùy thuộc vào bác sĩ và dịch vụ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "4. Tôi có thể dùng ứng dụng để đăng ký và lấy số thứ tự khám cho bệnh nhân khác không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Ứng dụng cho phép bạn đăng ký và lấy số thứ tự khám cho người thân hoặc bạn bè.",
                ),
              ),
              ListTile(
                title: const Text(
                  "5. Ứng dụng có hỗ trợ đăng ký khám 24/7 không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Ứng dụng hỗ trợ đăng ký khám bệnh 24/7, bạn có thể chọn thời gian khám bất kỳ khi nào.",
                ),
              ),
              ListTile(
                title: const Text(
                  "6. Sau khi đăng ký khám thành công tôi nhận được phiếu khám bệnh như thế nào?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Sau khi đăng ký thành công, bạn sẽ nhận được phiếu khám bệnh qua email hoặc tin nhắn trên ứng dụng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "7. Có thể thanh toán trực tuyến chi phí khám chữa bệnh bằng những phương thức nào?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Chúng tôi hỗ trợ thanh toán qua thẻ tín dụng, thẻ ghi nợ, ví điện tử, và chuyển khoản ngân hàng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "8. Làm sao tôi biết được là đã thanh toán thành công?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Sau khi thanh toán, bạn sẽ nhận được thông báo xác nhận thanh toán thành công qua email hoặc trong ứng dụng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "9. Tôi có thể đặt khám cho người nhà tôi được không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể đăng ký khám cho người thân hoặc bạn bè qua ứng dụng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "10. Đối tượng bệnh nhân nào có thể sử dụng ứng dụng?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Ứng dụng dành cho tất cả bệnh nhân cần đăng ký khám bệnh, từ trẻ em đến người lớn tuổi.",
                ),
              ),
              ListTile(
                title: const Text(
                  "11. Sau khi đã đăng ký khám thành công qua ứng dụng, có thể hủy phiếu khám không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể hủy phiếu khám trong vòng 24 giờ trước thời gian khám. Sau thời gian này, việc hủy sẽ bị tính phí.",
                ),
              ),
              ListTile(
                title: const Text(
                  "12. Tôi đến bệnh viện trễ hơn so với giờ khám đã đăng ký, vậy tôi có được khám hay không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu đến muộn, bạn vẫn có thể khám, nhưng có thể phải đợi thêm tùy vào tình trạng của các bệnh nhân khác.",
                ),
              ),
              ListTile(
                title: const Text(
                  "13. Chức năng của tổng đài 1900-2115",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Tổng đài hỗ trợ tư vấn, giải đáp thắc mắc về việc đăng ký khám bệnh và các dịch vụ liên quan.",
                ),
              ),
              ListTile(
                title: const Text(
                  "14. Chi tiết cước phí của tổng đài 1900-2115",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Cước phí của tổng đài 1900-2115 sẽ được tính theo quy định của nhà mạng, vui lòng tham khảo chi tiết trước khi gọi.",
                ),
              ),
              ListTile(
                title: const Text(
                  "15. Thời gian làm việc của tổng đài 1900-2115",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Tổng đài 1900-2115 hoạt động từ 8:00 sáng đến 10:00 tối hàng ngày.",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              "Vấn đề tài khoản",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            children: [
              ListTile(
                title: const Text(
                  "1. Mã số bệnh nhân là gì? Làm sao tôi có thể biết được mã số bệnh nhân của mình?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Mã số bệnh nhân là một mã định danh duy nhất để xác nhận thông tin của bạn trong hệ thống. Bạn có thể tìm mã số bệnh nhân của mình trong thông báo đăng ký khám hoặc trong hồ sơ của bạn trong ứng dụng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "2. Tôi quên mã số bệnh nhân của mình thì phải làm sao?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu bạn quên mã số bệnh nhân, vui lòng liên hệ với tổng đài hỗ trợ hoặc kiểm tra trong phần hồ sơ cá nhân của bạn trên ứng dụng để lấy lại mã số.",
                ),
              ),
              ListTile(
                title: const Text(
                  "3. Làm sao tôi biết bên mình đã có mã số bệnh nhân chưa?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu bạn chưa có mã số bệnh nhân, bạn sẽ được yêu cầu đăng ký tài khoản để tạo mã số. Bạn có thể kiểm tra trong hồ sơ cá nhân để xác nhận mã số đã được cấp hay chưa.",
                ),
              ),
              ListTile(
                title: const Text(
                  "4. Tôi có thể chọn tùy ý một hồ sơ bệnh nhân của người khác để đăng ký khám bệnh cho mình không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Không, bạn chỉ có thể đăng ký khám bệnh cho chính mình hoặc người thân có hồ sơ bệnh nhân hợp lệ trong hệ thống.",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              "Quy trình đặt lịch khám",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            children: [
              ListTile(
                title: const Text(
                  "1. Có thể đăng ký khám bệnh trong ngày bằng phần mềm không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Có, bạn có thể đăng ký khám bệnh trong ngày qua phần mềm nếu bác sĩ có lịch trống trong ngày đó.",
                ),
              ),
              ListTile(
                title: const Text(
                  "2. Có thể đăng ký khám bệnh trong khoảng thời gian nào?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể đăng ký khám bệnh trong khoảng thời gian làm việc của bệnh viện. Thời gian cụ thể sẽ được hiển thị trong ứng dụng khi bạn lựa chọn bác sĩ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "3. Khi đi khám bệnh, tôi có cần chuẩn bị gì không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn cần mang theo chứng minh thư, bảo hiểm y tế (nếu có), và bất kỳ tài liệu y tế liên quan như kết quả xét nghiệm hoặc toa thuốc (nếu có).",
                ),
              ),
              ListTile(
                title: const Text(
                  "4. Tôi có việc đột xuất hoặc bận không đến khám được, tôi muốn huỷ phiếu khám có được không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể hủy phiếu khám nếu thực hiện trong khoảng thời gian quy định. Sau thời gian đó, phí hủy sẽ được áp dụng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "5. Tôi có thể thay đổi thông tin khám đã đặt qua phần mềm không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn không thể thay đổi thông tin khám trên phiếu khám bệnh đã đặt thành công. Nếu cần thay đổi, bạn cần hủy lịch và đặt lại.",
                ),
              ),
              ListTile(
                title: const Text(
                  "6. Phần mềm có cho đăng ký khám bệnh với đối tượng bệnh nhân BHYT không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Có, phần mềm hỗ trợ đăng ký khám bệnh cho đối tượng bệnh nhân bảo hiểm y tế (BHYT).",
                ),
              ),
              ListTile(
                title: const Text(
                  "7. Nếu bác sĩ thay đổi lịch khám, tôi phải làm sao?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu lịch khám thay đổi, bạn sẽ nhận thông báo từ phần mềm và có thể chọn thời gian khám khác hoặc hủy lịch.",
                ),
              ),
              ListTile(
                title: const Text(
                  "8. Làm sao có thể chọn đúng chuyên khoa để đăng ký khám qua phần mềm?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể chọn chuyên khoa ngay từ giao diện chính khi đăng ký khám, phần mềm sẽ gợi ý các bác sĩ phù hợp với chuyên khoa đó.",
                ),
              ),
              ListTile(
                title: const Text(
                  "9. Tôi sẽ được khám bệnh vào đúng thời gian đã chọn, sau khi đăng ký khám qua phần mềm đúng không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn sẽ được khám vào đúng thời gian đã chọn, tuy nhiên, nếu có sự cố bất ngờ, bác sĩ hoặc bệnh viện sẽ thông báo cho bạn.",
                ),
              ),
              ListTile(
                title: const Text(
                  "10. Tôi đăng ký đã bị trừ tiền nhưng sao không nhận được mã số khám bệnh?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu bạn đã bị trừ tiền nhưng không nhận được mã số khám bệnh, vui lòng liên hệ với bộ phận hỗ trợ khách hàng để giải quyết.",
                ),
              ),
              ListTile(
                title: const Text(
                  "11. Tôi đã đăng ký thành công vậy khi đi khám tôi có phải xếp hàng gì không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Sau khi đăng ký thành công, bạn sẽ có thể khám bệnh mà không phải xếp hàng. Tuy nhiên, trong trường hợp đông bệnh nhân, bạn có thể cần chờ đợi một thời gian ngắn.",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              "Vấn đề thanh toán",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            children: [
              ListTile(
                title: const Text(
                  "1. Điều kiện để được hoàn tiền là gì?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Điều kiện để được hoàn tiền là bạn đã thanh toán nhưng không sử dụng dịch vụ khám bệnh hoặc đã hủy lịch khám trong thời gian quy định.",
                ),
              ),
              ListTile(
                title: const Text(
                  "2. Hoàn tiền như thế nào? Bao lâu thì tôi nhận lại được tiền hoàn?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Quá trình hoàn tiền sẽ được thực hiện qua phương thức thanh toán đã sử dụng. Thời gian hoàn tiền có thể mất từ 5 đến 7 ngày làm việc tùy thuộc vào ngân hàng hoặc ví điện tử của bạn.",
                ),
              ),
              ListTile(
                title: const Text(
                  "3. Tôi không có bất kỳ một thẻ khám bệnh hoặc thẻ ngân hàng nào để thanh toán, vậy tôi phải làm sao?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể chọn phương thức thanh toán qua ví điện tử hoặc thanh toán trực tiếp tại bệnh viện. Phần mềm hỗ trợ nhiều phương thức thanh toán khác nhau.",
                ),
              ),
              ListTile(
                title: const Text(
                  "4. Thông tin thanh toán của tôi có bị lộ khi tôi tiến hành thanh toán trên phần mềm không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Không, thông tin thanh toán của bạn được bảo mật hoàn toàn. Phần mềm sử dụng mã hóa SSL và các biện pháp bảo mật tiêu chuẩn để bảo vệ dữ liệu của bạn.",
                ),
              ),
              ListTile(
                title: const Text(
                  "5. Tôi đăng nhập đúng tên tài khoản nhưng không thanh toán được?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu bạn gặp vấn đề khi thanh toán, hãy kiểm tra lại thông tin thẻ, số dư tài khoản, hoặc thử phương thức thanh toán khác. Nếu vẫn không thể thanh toán, vui lòng liên hệ với bộ phận hỗ trợ khách hàng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "6. Tôi muốn đăng ký khám online nhưng đến trực tiếp bệnh viện để thanh toán được không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Có, bạn có thể đến trực tiếp bệnh viện để thanh toán sau khi đăng ký khám online. Tuy nhiên, bạn cần thông báo trước với bệnh viện về việc thanh toán tại chỗ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "7. Tôi nhập tài khoản thẻ nhưng bấm xác thực hoài không được?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu gặp sự cố khi xác thực thẻ, hãy kiểm tra lại thông tin thẻ (số thẻ, ngày hết hạn, mã CVV). Nếu vẫn không xác thực được, vui lòng liên hệ với ngân hàng hoặc bộ phận hỗ trợ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "8. Phí tiện ích là gì?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Phí tiện ích là khoản phí nhỏ tính thêm vào khi sử dụng dịch vụ thanh toán qua ứng dụng, ví dụ như phí dịch vụ thanh toán hoặc phí giao dịch qua ngân hàng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "9. Cách tính phí tiện ích",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Phí tiện ích sẽ được tính dựa trên tổng số tiền bạn thanh toán, thường dao động từ 1-2% tổng giá trị giao dịch hoặc theo một mức phí cố định tùy vào phương thức thanh toán.",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              "Vấn đề trả sau qua Fundiin",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            children: [
              ListTile(
                title: const Text(
                  "1. Quy trình thu hồi nợ diễn ra như thế nào?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Quy trình thu hồi nợ sẽ được thực hiện sau khi đến hạn thanh toán. Fundiin sẽ thông báo về việc thu hồi nợ và yêu cầu khách hàng thanh toán số tiền còn lại hoặc sẽ áp dụng các biện pháp thu hồi theo chính sách của công ty.",
                ),
              ),
              ListTile(
                title: const Text(
                  "2. Hạn mức tối đa Khách Hàng có thể sử dụng?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Hạn mức tối đa mà khách hàng có thể sử dụng sẽ tùy thuộc vào lịch sử tín dụng của khách hàng và chính sách của Fundiin. Thông thường, hạn mức sẽ được nâng lên theo thời gian sử dụng dịch vụ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "3. Nếu thanh toán trễ hơn kỳ hạn, tôi sẽ phải trả mức phí bao nhiêu?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu thanh toán trễ, bạn sẽ phải chịu mức phí trễ hạn theo quy định của Fundiin. Mức phí này sẽ được tính dựa trên số ngày trễ và tổng số tiền còn lại chưa thanh toán.",
                ),
              ),
              ListTile(
                title: const Text(
                  "4. Lý do Khách Hàng bị từ chối là gì?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Khách hàng có thể bị từ chối nếu không đáp ứng được các yêu cầu tín dụng, như lịch sử tín dụng không tốt, không đủ thu nhập hoặc có nợ xấu trong hệ thống ngân hàng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "5. Tôi có thể thanh toán tối đa bao nhiêu qua Fundiin?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể thanh toán số tiền tối đa theo hạn mức tín dụng mà Fundiin cấp cho bạn. Nếu bạn cần thay đổi hạn mức, hãy liên hệ với bộ phận hỗ trợ khách hàng.",
                ),
              ),
              ListTile(
                title: const Text(
                  "6. Nếu không còn nhu cầu sử dụng, tôi có thể hủy dịch vụ không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Bạn có thể hủy dịch vụ bất cứ lúc nào bằng cách liên hệ với bộ phận hỗ trợ của Fundiin. Tuy nhiên, nếu bạn còn dư nợ, bạn sẽ phải thanh toán hết trước khi hủy dịch vụ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "7. Tôi sẽ phải chi trả những loại phí nào?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Các loại phí bạn có thể phải trả bao gồm phí dịch vụ, phí trễ hạn (nếu có), phí chuyển đổi trả góp (nếu áp dụng) và các phí liên quan khác theo chính sách của Fundiin.",
                ),
              ),
              ListTile(
                title: const Text(
                  "8. Có được chuyển đổi trả góp theo tháng?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Có, Fundiin cho phép bạn chuyển đổi khoản thanh toán thành trả góp theo tháng. Tuy nhiên, bạn cần phải đáp ứng các điều kiện tín dụng và lựa chọn phương thức trả góp phù hợp.",
                ),
              ),
              ListTile(
                title: const Text(
                  "9. Nếu tôi không thanh toán dư nợ trong thời gian quy định thì tôi sẽ gặp các trường hợp gì?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu không thanh toán đúng hạn, bạn sẽ bị áp dụng các phí trễ hạn, và Fundiin có thể thực hiện các biện pháp thu hồi nợ theo quy định, bao gồm thông báo nhắc nhở hoặc chuyển sang các cơ quan thu hồi nợ.",
                ),
              ),
              ListTile(
                title: const Text(
                  "10. Trường hợp tôi đã thanh toán hết thì có mất chi phí duy trì tài khoản không?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Nếu bạn đã thanh toán hết nợ và không sử dụng dịch vụ tiếp, bạn sẽ không phải chịu phí duy trì tài khoản. Tuy nhiên, nếu bạn tiếp tục sử dụng dịch vụ, phí duy trì tài khoản có thể áp dụng.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
