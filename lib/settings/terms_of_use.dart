import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anime_fanarts/utils/colors.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CollectionReference importantPagesCollection = FirebaseFirestore.instance.collection('importantPages');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: Text(
          'Animizu Terms of use'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: importantPagesCollection.doc('ZMfhmc4NE3usr6U8M2Tl').get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {

                Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;

                return Text(
                  '${data['termsOfUse'].toString().replaceAll('/n', '\n')}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                );
              }
            
              return Center(
                child: LoadingAnimation()
              );

              // return Column(
              //   children: [
              //     RichText(
              //       text: TextSpan(
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16,
              //         ),
              //         children: <TextSpan>[
              //           TextSpan(
              //             text: 'Please read these Terms of Service carefully. They contain the legal terms and conditions that govern your use of services provided to you by Animizu. Here Animizu is also referred to in these Terms as "we", "our", and "us". By using our Service, you agree to be bound to these Terms, which contains provisions applicable to all users of our Service. If you choose to register(Sign up) as a member of our Service you will be asked to read, and agree to our terms.\n\n',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold
              //             ),
              //           ),
              //           TextSpan(
              //             text: '1. Availability\n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'This Service is provided by Animizu on an "AS IS" and "AS AVAILABLE" basis and Animizu reserves the right to modify, suspend or discontinue the Service, in its sole discretion, at any time and without notice. You agree that Animizu is and will not be liable to you for any modification, suspension or discontinuance of the Service.\n\n',
              //           ),
              //           TextSpan(
              //             text: '2. Privacy \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: "Animizu has a firm commitment to safeguarding your privacy. Please review Animizu's Privacy Policy.\n\n",
              //           ),
              //           TextSpan(
              //             text: '3. Trademarks \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'All brand, product and service names used in this Service which identify Animizu or third parties and their products and services are proprietary marks of Animizu and/or the relevant third parties. Nothing in this Service shall be deemed to confer on any person any license or right on the part of Animizu or any third party with respect to any such image, logo or name. .\n\n',
              //           ),
              //           TextSpan(
              //             text: '4. Copyright \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'Amimizu is, unless otherwise stated, the owner of all copyright and data rights in the Service and its contents. Individuals who have posted works to Amimizu are either the copyright owners of the component parts of that work or are posting the work under license from a copyright owner or his or her agent or otherwise as permitted by law. You may not reproduce, distribute, publicly display or perform, or prepare derivative works based on any of the Content including any such works without the express, written consent of Amimizu or the appropriate owner of copyright in such works. Amimizu does not claim ownership rights in your works or other materials posted by you to Amimizu (Your Content). You agree not to distribute any part of the Service other than Your Content in any medium other than as permitted in these Terms of Service or by use of functions on the Service provided by us. You agree not to alter or modify any part of the Service unless expressly permitted to do so by us or by use of functions on the Service provided by us.\n\n',
              //           ),
              //           TextSpan(
              //             text: '5. Reporting Copyright Violations \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'Amimizu respects the intellectual property rights of others and expects users of the Service to do the same. At Amimizu’s discretion and in appropriate circumstances, Amimizu may remove Your Content submitted to the platform, terminate the accounts of users or prevent access to the platform by users who infringe the intellectual property rights of others. If you believe the copyright in your work or in the work for which you act as an agent has been infringed through this Service, please contact us for notice of claims of copyright infringement, through violations@amimizu.com. You must provide us with substantially the following information,  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • A physical or electronic signature of a person authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • Identification of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works at a single online site are covered by a single notification, a representative list of such works at that site.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • Identification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled, and information reasonably sufficient to permit the service provider to locate the material.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • Information reasonably sufficient to permit the service provider to contact the complaining party, such as an address, telephone number, and, if available, an electronic mail address at which the complaining party may be contacted. \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • A statement that the complaining party has a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • A statement that the information in the notification is accurate, and under penalty of perjury, that the complaining party is authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '6. External Links  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'Amimizu may provide links to third-party websites or resources. You acknowledge and agree that Animizu is not responsible or liable for: the availability or accuracy of such websites or resources; or the Content, products, or services on or available from such websites or resources. Links to such websites or resources do not imply any endorsement by Animizu of such websites or resources or the Content, products, or services available from such websites or resources. You acknowledge sole responsibility for and assume all risk arising from your use of any such websites or resources.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '7. Third Party Software  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'As a convenience, we may make third-party software available through the Service. To use the third-party software, you must agree to the terms and conditions imposed by the third party provider and the agreement to use such software will be solely between you and the third party provider. By downloading third party software, you acknowledge and agree that the software is provided on an "AS IS" basis without warranty of any kind. In no event shall Amimizu be liable for claims or damages of any nature, whether direct or indirect, arising from or related to any third-party software downloaded through the Service.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '8. Conduct  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'You agree that you shall not interfere with or disrupt (or attempt to interfere with or disrupt) this Service or servers or networks connected to this Service, or to disobey any requirements, procedures, policies or regulations of networks connected to this Service; or provide any information to Amimizu that is false or misleading, that attempts to hide your identity or that you do not have the right to disclose. Amimizu does not endorse any content placed on the Service by third parties or any opinions or advice contained in such content. You agree to defend, indemnify, and hold harmless Amimizu, its officers, directors, employees and agents, from and against any claims, liabilities, damages, losses, and expenses, including, without limitation, reasonable legal and expert fees, arising out of or in any way connected with your access to or use of the Services, or your violation of these Terms.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '9. Disclaimer of Warranty and Limitation of Liability  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: "Animizu makes no representations or warranties of any kind, express or implied as to the operation of the service, or the content or products, provided through the service. you expressly agree that your use of the service is at your sole risk. Animizu disclaims all warranties, express or implied, including without limitation, implied warranties of merchantability, fitness for a particular purpose, and non-infringement, to the fullest extent permitted by law. Animizu makes no warranty as to the security, reliability, timeliness, and performance of this service. you specifically acknowledge that Animizu is not liable for your defamatory, offensive or illegal conduct, or such conduct by third parties, and you expressly assume all risks and responsibility for damages and losses arising from such conduct. except for the express, limited remedies provided herein, and to the fullest extent allowed by law, Animizu shall not be liable for any damages of any kind arising from use of the service, including but not limited to direct, indirect, incidental, consequential, special, exemplary, or punitive damages, even if Animizu has been advised of the possibility of such damages. the foregoing disclaimers, waivers and limitations shall apply notwithstanding any failure of essential purpose of any limited remedy. some jurisdictions do not allow the exclusion of or limitations on certain warranties or damages. Therefore, some of the above exclusions or limitations may not apply to you. in no event shall Animizu's aggregate liability to you exceed the amounts paid by you to Animizu pursuant to this agreement.  \n\n",
              //           ),
              //           TextSpan(
              //             text: '10. Amendment of the Terms  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'We reserve the right to amend these Terms from time to time in our sole discretion. If you have registered as a member, we may notify you of any material changes to these Terms (and the effective date of such changes) by sending a notification or emailing. If you continue to use the Service after the effective date of the revised Terms, you will be deemed to have accepted those changes. If you do not agree to the revised Terms, your sole remedy shall be to discontinue using the Service.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '11. General  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'These Terms constitute the entire agreement between Amimizu and you with respect to your use of the Service. Amimizu’s failure to enforce any right or provision in these Terms shall not constitute a waiver of such right or provision. If a court should find that one or more provisions contained in these Terms is invalid, you agree that the remainder of the Terms shall be enforceable. Amimizu shall have the right to assign its rights and/or delegate its obligations under these Terms, in whole or in part, to any person or business entity. You may not assign your rights or delegate your obligations under these Terms without the prior written consent of Amimizu.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '12. Registration  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'To register as a member of the Service you must be 13 years or lawfully permitted to enter into and form contracts under applicable law. In no event may minors submit Content to the Service. You agree that the information that you provide to us upon registration and at all other times will be true, accurate, current and complete. You also agree that you will ensure that this information is kept accurate and up to date at all times. This is especially important with respect to your email address, since that is the primary way in which we will communicate with you about your account and your orders.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '13. Password  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'When you register as a member you will be asked to provide a password. You are responsible for safeguarding the password and you agree not to disclose your password to any third party. You agree that you shall be solely responsible for any activities or actions under your password, whether or not you have authorized such activities or actions. You shall immediately notify Amimizu of any unauthorized use of your password.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '14. Submitting Content  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'As a registered member of the Service, you will be granted the privilege of submitting certain types of Your Content, known as "Artist Materials," for display on your user page. Prior to submitting Artist Materials, you must accept the additional terms and conditions of the Submission Policy, which is incorporated into, and forms a part of, the Terms.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '15. Copyright in Your Content  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'Amimizu does not claim ownership rights in Your Content. For the sole purpose of enabling us to make your Content available through the Service, you grant to Amimizu a non-exclusive, royalty-free license to reproduce, distribute, re-format, store, prepare derivative works based on, and publicly display and perform Your Content. Please note that when you upload Content, third parties will be able to copy, distribute and display your Content using readily available tools on their computers for this purpose although other than by linking to your Content on Amimizu any use by a third party of your Content could violate paragraph 4 of these Terms and Conditions unless the third party receives permission from you by license.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '16. Monitoring Content  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: 'Amimizu has no ability to control the Content you may upload, post or otherwise transmit using the Service and does not have any obligation to monitor such Content for any purpose. You acknowledge that you are solely responsible for all Content and material you upload, post or otherwise transmit using the Service.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '17. Storage Policy  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: "At this time, Amimizu provides free online storage of Your Content to registered members of the Service. However, you acknowledge and agree that Amimizu may, at its option, establish limits concerning your use of the Service, including without limitation the maximum number of days that Your Content will be retained by the Service, the maximum size of any Content files that may be stored on the Service, the maximum disk space that will be allotted to you for the storage of Content on Amimizu's servers. Furthermore, you acknowledge that Amimizu reserves the right to terminate or suspend accounts that are inactive, in Amimizu's sole discretion, for an extended period of time (thus deleting or suspending access to your Content). Without limiting the generality of Section 9, Amimizu shall have no responsibility or liability for the deletion or failure to store any Content maintained on the Service and you are solely responsible for creating back-ups of Your Content. You further acknowledge that Amimizu reserves the right to modify its storage policies from time to time, with or without notice to you.  \n\n",
              //           ),
              //           TextSpan(
              //             text: '18. Conduct  \n\n',
              //           ),
              //           TextSpan(
              //             text: 'You are responsible for all of Your Content you upload, download, and otherwise copy, distribute and display using the Service. You must have the legal right to copy, distribute and display all parts of any content that you upload, download and otherwise copy, distribute and display. Content provided to you by others, or made available through websites, magazines, books and other sources, are protected by copyright and should not be uploaded, downloaded, or otherwise copied, distributed or displayed without the consent of the copyright owner or as otherwise permitted by law.  \n\n You agree not to use the Service: \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • for any unlawful purposes  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • to upload, post, or otherwise transmit any material that is obscene, offensive, blasphemous, pornographic, unlawful, threatening, menacing, abusive, harmful, an invasion of privacy or publicity rights, defamatory, libelous, vulgar, illegal or otherwise objectionable  \n\n',
              //           ),
              //           TextSpan(
              //             text: "   • to upload, post, or otherwise transmit any material that infringes any copyright, trade mark, patent or other intellectual property right or any moral right or artist's right of any third party including, but not limited to, Amimizu or to facilitate the unlawful distribution of copyrighted content or illegal content  \n\n",
              //           ),
              //           TextSpan(
              //             text: '   • to harm minors in any way, including, but not limited to, uploading, posting, or otherwise transmitting content that violates child pornography laws, child sexual exploitation laws or laws prohibiting the depiction of minors engaged in sexual conduct, or submitting any personally identifiable information about any child under the age of 13  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • to forge headers or otherwise manipulate identifiers in order to disguise the origin of any Content transmitted through the Service  \n\n',
              //           ),
              //           TextSpan(
              //             text: "   • to upload, post, or otherwise transmit any material which is likely to cause harm to Amimizu or anyone else's computer systems, including but not limited to that which contains any virus, code, worm, data or other files or programs designed to damage or allow unauthorized access to the Service which may cause any defect, error, malfunction or corruption to the Service  \n\n",
              //           ),
              //           TextSpan(
              //             text: '   • for any commercial purpose, except as expressly permitted under these Terms  \n\n',
              //           ),
              //           TextSpan(
              //             text: '   • to sell access to the Service on any other website or to use the Service on another website for the primary purpose of gaining advertising or subscription revenue other than a personal blog or social network where the primary purpose is to display content from Amimizu by hyperlink and not to compete with Amimizu.  \n\n',
              //           ),
              //           TextSpan(
              //             text: '19. Commercial Activities  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: "Commercial activities mean the offering, solicitation or sale of goods or services by anyone other than Amimizu. Commercial activities with respect to the arts are permitted for registered members acting as individuals, for small corporations or partnerships engaged primarily in art-related activities in which one or more of the principals is a registered member or for those seeking to retain the services or works of a registered member. Commercial activities in the form of paid advertising on the Service are subject to the terms and conditions relating to the purchase of such advertising. No other commercial activities are permitted on or through the Service without Amimizu's written approval. Any interactions with members of the Service with respect to commercial activities including payment for and delivery of goods and/or services and any terms related to the commercial activities including conditions, warranties or representations and so forth are solely between you and the other member. Paragraph 9, above, of these Terms of Service specifically applies with respect to commercial activities.   \n\n",
              //           ),
              //           TextSpan(
              //             text: '20. Suspension and Termination of Access and Membership  \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: "You agree that Amimizu may at any time, and without notice, suspend or terminate any part of the Service, or refuse to fulfill any order, or any part of any order or terminate your membership and delete any Content stored on the Amimizu Site, in Amimizu's sole discretion, if you fail to comply with the Terms or applicable law.  \n\n",
              //           ),
              //           TextSpan(
              //             text: 'If you have any comments or questions about the Service please contact us by email at contact@animizu.com.  \n\n',
              //           ),
              //         ]
              //       )
              //     ),
              //   ]
              // );
            }
          )
        )
      )
    );
  }
}