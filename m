From: Steven Dake <sdake@mvista.com>
Subject: rescan bug on 2.5.70 ?
Date: Fri, 30 May 2003 14:08:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED7C847.3090203@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw-az.mvista.com ([65.200.49.158]:43515 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263979AbTE3VCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 17:02:41 -0400
Received: from mvista.com (persist.az.mvista.com [10.50.1.246])
	by zipcode.az.mvista.com (8.9.3/8.9.3) with ESMTP id OAA15256
	for <linux-scsi@vger.kernel.org>; Fri, 30 May 2003 14:29:29 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

I attempted
echo "1" > rescan within a device in the scsi sysfs tree on 2.5.70.

The kernel repeatadly printed out the SDA device information.  The 
system was still usable, but it appeared the rescan code was stuck in a 
loop which dumped printks continuously.  Only way out was a reset.

Anyone else seen this behavior ?

Thanks
-steve

