From: Guennadi Liakhovetski <gl@dsa-ac.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Tue, 18 Nov 2003 11:22:59 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0311181119000.2153-100000@pcgl.dsa-ac.de>
References: <20031118092844.GA2995@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dsa-ac.de ([62.112.80.99]:20235 "EHLO k2.dsa-ac.de")
	by vger.kernel.org with ESMTP id S262397AbTKRKXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 05:23:07 -0500
In-Reply-To: <20031118092844.GA2995@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org

On Tue, 18 Nov 2003, Kurt Garloff wrote:

> Guennadi,
>
> I have no clue what's going wrong yet with INQUIRY. I believe it has
> to do with some pci mapping we get wrong.
>
> I deferred the pci mapping to StartSCSI, so we don't create mappings
> for queued SRBs. Some hardware may have IOMMUs and will have limited
> sizes available.
>
> It also allows to clean up some code as we can rely on a mapping being
> created if needed upon StartSCSI. Likewise, I moved pci mapping cleanup
> to SRBdone. Every command should go through here.
> I still need to check the error handling paths, though.
>
> Patch is on top of yours.

Great! Thanks. I, probably, won't have (much) time today, but I'll
continue tomorrow evening.

> Likely, it won't help with the INQUIRY problem :(

Well, probably will have to put lots of dirty debugging printk()'s of
various addresses, etc.

> I still have to get a machine with the DC390 up again.

Yep, testing one / some of those would be needed too - I only have an
onboard 53C974 in a Compaq PC.

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany

