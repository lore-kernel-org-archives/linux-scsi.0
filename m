From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: [ANNOUNCE] sdparm 0.92
Date: Wed, 25 May 2005 01:49:20 +0200
Message-ID: <4293BD80.1050503@danbbs.dk>
References: <428DC633.5050403@torque.net>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:20004 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S262174AbVEXXsm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 19:48:42 -0400
In-Reply-To: <428DC633.5050403@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> sdparm is a command line utility designed to get and set
> SCSI disk parameters (cf hdparm for ATA disks). More generally
> it gets and sets mode page information on SCSI devices or devices
> that use a SCSI command set (e.g. CD/DVD drives (any transport)
> and SCSI tape drives). It also can list VPD pages including
> the device identification page.
> 
> For more information and downloads (tarball, rpm and deb
> packages) see:
> http://www.torque.net/sg/sdparm.html

Nice! Just got it and tried on an external usb disk.
One feature I could use, probably others as well:
Could you add the ability to spin down/up a scsi disk?
I'd really like this for exteral (usb) disks.

Doesn't seem it can; if I missed it, I'm sorry..

-- 
Kind regards,
Mogens Valentin

