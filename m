From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Mon, 11 Sep 2006 18:29:05 +0200
Message-ID: <20060911162905.GB17756@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <1157941050.3467.21.camel@mulgrave.il.steeleye.com> <20060911095109.GA4953@stat.unipd.it> <450554CF.4060906@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stavromula.stat.unipd.it ([147.162.35.208]:57518 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S964999AbWIKQ3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 12:29:17 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id A16081AF57533
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 18:29:13 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 01359-06 for <linux-scsi@vger.kernel.org>;
	Mon, 11 Sep 2006 18:29:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <450554CF.4060906@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2006 at 08:21:35AM -0400, James Smart wrote:
> What this tells me is that the reporting as a scsi-4 device is
> telling the midlayer to use Report Luns, and that Report Luns is likely
> failing on this target. If the manual scans succeed, it says the
> luns are there, but were not reported in Report Luns. What you are
> encountering is an interaction between the target device and the midlayer
> scan behaviors. You should have like behavior on other adapters.
> Sounds like this device could use a device list entry.

	I can post some other log if someone finds it useful, anyway
	other adapters (serveraid, adaptech, iscsi) on the same system 
	fill also their /proc stuff, this is the reason why I never 
	noticed my scsi userspace tools were obsolete. Debian Sarge
	being supposedly _stable_, it was a bit a surprise for me...
	
	It is likely that this kind of problem will show up frequently 
	while old userpace tools are not fully updated and transition to
	sys completed.
	
> Please note: it is general practice that /proc stuff for adapters is
> being deprecated in lieu of using the /sys/class/scsi_host/host<#>
> attributes. This has been true for the lpfc driver as it was a
> requirement when we first integrated into kernel.org around 2.6.10.
> Expect other adapters to behave the same as lpfc.

	OK, Thank you.


	Alberto

