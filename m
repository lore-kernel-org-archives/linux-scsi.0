From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sysfs support for sg
Date: Thu, 08 Jan 2004 12:11:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFCBC4D.1010209@torque.net>
References: <20040107223341.GA23799@suse.de> <20040107224028.GA24290@suse.de> <3FFCB74B.9090102@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:54283 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263185AbUAHCNX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 21:13:23 -0500
Received: from torque.net (d-234-157.stlucia.uq.net.au [203.101.234.157])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i082DIci023261
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2004 12:13:20 +1000 (GMT+1000)
In-Reply-To: <3FFCB74B.9090102@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:

> Currently the sg driver lacks driver parameter support within sysfs
> (e.g. 'allow_dio' as found in the /proc/scsi/sg directory).
> Interestingly the st and osst drivers have /sys/bus/scsi/drivers/st
> and osst directories (sd and st drivers also get directories if
> their drivers are loaded). It is useful to be able to access
> ULDs _prior_ to any (scsi) devices being attached which is not
> possible under lk 2.4 .

... and I missed the most glaring omission from /sys/bus/scsi/drivers
which is the scsi mid level driver itself. Many interesting potential
parameters come to mind, 'no_scan' for example.

Doug Gilbert

