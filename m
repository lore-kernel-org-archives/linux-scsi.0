From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 0/4] qla4xxx: Patches for iSCSI flash node mgmt support
Date: Mon, 25 Mar 2013 12:29:04 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD28C127@avmb3.qlogic.org>
References: <514D4BA7.7060308@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:32865
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757391Ab3CYM3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 08:29:16 -0400
In-Reply-To: <514D4BA7.7060308@cs.wisc.edu>
Content-Language: en-US
Content-ID: <570026FA5E4FA349A35AE71AA17506FD@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Poornima Vonti <poornima.vonti@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>



-----Original Message-----
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Saturday 23 March 2013 11:58 AM
To: Vikas <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
<linux-scsi@vger.kernel.org>, Lalit Chandivade
<lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>,
Poornima Vonti <poornima.vonti@qlogic.com>, Manish Rangankar
<manish.rangankar@qlogic.com>
Subject: Re: [PATCH 0/4] qla4xxx: Patches for iSCSI flash node mgmt support

>On 03/22/2013 06:41 AM, vikas.chaudhary@qlogic.com wrote:
>> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>>
>> James,
>>
>> Following patches allows iscsiadm to manage iSCSI target information
>> stored on adapter flash on per host basis and and perform various
>> operations like add, delete, login, logout, and update the target
>> information.
>>
>> Please apply these patches to the scsi tree "misc" branch at your
>> earliest convenience.
>>
>> Adheer Chandravanshi (3):
>>       scsi_transport_iscsi: Add flash node mgmt support
>>       libiscsi: export function iscsi_switch_str_param
>>       qla4xxx: Add flash node mgmt support
>>
>
>In the last patch, the
>
>+#define DEV_TYPE_IPV4  "ipv4"
>+#define DEV_TYPE_IPV6  "ipv6"
>
>should probably go in the iscsi class, but if it is ok with James then I
>think that can be done in a later cleanup patch since there has been a
>lot of work done on these patches already and we should get them in.

Thanks a lot for feedback.
I am sending following two patches to make above macro generic.

        scsi_transport_iscsi: Declare portal type string macros for generic use
        qla4xxx: Replace dev type macros with generic portal type macros

Also resending following driver version patch as it never went to the list.

        qla4xxx: Update driver version to 5.03.00-k7


Thanks,
Vikas.




________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

