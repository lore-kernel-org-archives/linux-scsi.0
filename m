From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 10:24:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031215182412.GC1259@praka.local.home>
References: <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org> <3FDDC867.9040500@cri74.org> <3FDDCE2F.4030401@leosandbox.org> <3FDDDE09.2040602@cri74.org> <3FDDE685.6050601@leosandbox.org> <3FDDEC90.4020403@cri74.org> <3FDDF067.4050805@leosandbox.org> <3FDDF10E.4030607@cri74.org> <3FDDF619.2090003@leosandbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:20150 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S264106AbTLOSax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 13:30:53 -0500
Content-Disposition: inline
In-Reply-To: <3FDDF619.2090003@leosandbox.org>
List-Id: linux-scsi@vger.kernel.org
To: r35157anc3 <leo@leosandbox.org>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org

> I recently read an article on iSCSI and FCIP. That's what initially got 
> me interested in this. I think this is actually what I'm wanting to do 
> here. Do you know if the qla 2300 HBA is capable of iSCSI? 
>

No, the 2xxx series HBAs are *not* iSCSI HBAs.  QLogic does make iSCSI
HBAs (the 4xxx series cards), info at qlogic.com.

> Is there a 
> linux driver for iSCSI or any plans for one?
> 

For the 4xxx series HBAs, yes.

Regards,
Andrew Vasquez
