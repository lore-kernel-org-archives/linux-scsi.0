From: "Mohan Kumar M." <MohanKumarM@AmiIndia.co.in>
Subject: Driver Problem
Date: Thu, 17 Jul 2003 14:17:51 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <005e01c34c40$20383bc0$5b00000a@RiseOfMachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="x-user-defined"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.129.222.186] ([203.129.222.186]:18187 "EHLO miami.chance")
	by vger.kernel.org with ESMTP id S271386AbTGQIpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 04:45:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
I have written a low level scsi driver for our scsi/raid controller.

The driver is working fine in Kernel v.2.4.18-3, but its not working in
Kernel v.2.4.19 onwards! (System crashes!!!!!)

I am not using interrupts, SG Lists. 

Is SCSI subsystem has been changed from 2.4.18 to 2.4.19??

Can anyone help me to solve this problem?

          =-=
Thanks n Regards,
        Mohan.
          =-=




