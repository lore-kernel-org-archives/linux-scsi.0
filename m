From: Jim.Roarick@Bull.com
Subject: SCSI_IOCTL_GET_IDLUN
Date: Wed, 12 May 2004 10:33:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFEC3573DC.7085A76C-ON07256E92.00606938-07256E92.00606ED8@az05.bull.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lionfish.bull.com ([141.112.4.90]:36037 "EHLO
	lionfish.az05.bull.com") by vger.kernel.org with ESMTP
	id S265137AbUELRdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2004 13:33:19 -0400
Received: from us-phx1.az05.bull.com (us-phx1.az05.bull.com [141.112.40.1])
	by lionfish.az05.bull.com (8.12.10/8.12.10) with ESMTP id i4CHXIvP010808
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2004 10:33:18 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have an application that does an open of a pseudo tape device ( 
/dev/st(x) ), followed by an ioctl (SCSI_IOCTL_GET_IDLUN) to get the 
address information. This worked fine in 2.4.6-20 and 2.6.1 but in 2.6.5 
returns null with no error indicated.

Did something change in mid-stream and, if so, how does one make it work 
again?

Sorry for the lack of a low level description, I am neither a kernel 
person or a driver person, merely an application person.


