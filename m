From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] remove a bogus check in sym2 driver
Date: Tue, 24 Jun 2003 18:20:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624082018.GC927@krispykreme>
References: <20030624033422.GB927@krispykreme> <1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:14055 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264398AbTFXIGP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 04:06:15 -0400
Content-Disposition: inline
In-Reply-To: <1056441769.14611.4.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, akpm@digeo.com


> Hardly. When you move to scsi hotplug you'll still have to work around
> the boxes where the same device pops up multiple times.
> 
> Just check the domain is 0 ?

I would have thought these things would be done at a higher level (eg
the x86 probe code). Whats there to stop this broken bios from showing
network cards up twice?

Anton
