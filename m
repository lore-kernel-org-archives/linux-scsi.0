From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Fri, 4 May 2012 03:29:54 -0700
Message-ID: <CBC9ABE0.E8C1%vikas.chaudhary@qlogic.com>
References: <4FA3ACC0.7000106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53803 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2EDKaH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:30:07 -0400
In-Reply-To: <4FA3ACC0.7000106@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>


-----Original Message-----
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Fri, 4 May 2012 03:17:36 -0700
To: Admin <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
<linux-scsi@vger.kernel.org>, Lalit Chandivade
<lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej
Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
failure

>On 05/04/2012 05:00 AM, Vikas Chaudhary wrote:
>>> # echo 6 > /sys/class/scsi_host/host7/device/fw_dump
>
>echo adds a newline by default. If you do echo -n it does not.

I tried with 'echo -n' I am still getting garbage data from sysfs
attribute.

>
>Does simple_strtol handle that but kstrol not handle it?

Yes, simple_strtol handle this case.


Here are logs:

May  4 16:01:01 magana kernel: ------------------------------------------
May  4 16:01:01 magana kernel: qla4xxx 0000:18:00.5: Buf =
4./../../host12      <-- garbage data from sysfs attribute
May  4 16:01:01 magana kernel: ------------------------------------------
May  4 16:01:01 magana kernel: qla4xxx 0000:18:00.5: simple strtol val =
4            <-- simple_strtol return correct value
May  4 16:01:01 magana kernel: qla4xxx 0000:18:00.5:
May  4 16:01:01 magana kernel: Error -22                                                     <-- error from kstrol
May  4 16:01:01 magana kernel: qla4xxx 0000:18:00.5: Error Converted Val
-2129482613


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

