From: Donald.Huang@ite.com.tw
Subject: RE: Driver request: ITE8212
Date: Thu, 5 Aug 2004 19:42:03 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <884B07FD576C3F49938D233F0E0A2B002FA68C@itemail1.internal.ite.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bsd.ite.com.tw ([210.208.198.222]:63754 "EHLO bsd.ite.com.tw")
	by vger.kernel.org with ESMTP id S267597AbUHELmM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2004 07:42:12 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: alan@redhat.com
Cc: arjanv@redhat.com, linux-scsi-owner@vger.kernel.org, linux-scsi@vger.kernel.org, mark.lu@accusys.com.tw

>I suspect it is as it has been developed by the experts on the hardware
>however it fakes up the device as a SCSI device which doesn't seem ideal
>to me - maybe there is a good reason to do so that I missed ?
I just asked the original driver creator , Mark Lu , 
and he said when he developed the IDE driver  it occurs some I/O control error in the firmware.
It  works well as a normal IDE , but occurs I/O control error as a RAID.
So he changed it as a SCSI device and solved the situation.

He also glad that the IT8212 driver can get the help from you.
I think the most important thing is the hardware can work well to let it can be used by linux user , 
and the others doesn't matter .

We also joy to see the IT8212 can works well as an IDE device.

>Thanks for the nice hardware, I wish I'd know about it a year or two ago 8)
Thanks for your praise. 
ITE will work hard to develop more  nice hardware. 
