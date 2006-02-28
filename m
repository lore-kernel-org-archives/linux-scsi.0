From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Compaq Fiber Channel Array RM4000 / Scsi middle ware driver
Date: Mon, 27 Feb 2006 17:40:43 -0700
Message-ID: <20060228004043.GH27759@parisc-linux.org>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at> <Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at> <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38064 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751001AbWB1Ako
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 19:40:44 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Feb 28, 2006 at 01:32:03AM +0100, Ingo Flaschberger wrote:
> Hello again,
> 
> >Where should the "middleware", Compaq Fiber Channel Array RM4000, 
> >TYPE_RAID driver reside in the kernel?
> >
> >scsi? char? block?

It should be a SCSI upper-level driver like sd.c, sr.c, st.c and osst.c.
It may make most sense for it to be implemented as a part of sd.c,
or it might be better to do it by implementing a new raid_sd.c.

> at which kernel version in detail the patch should apply?
> (sorry, I'm new).

Start with 2.6.16-rc5 (the most recent release by Linus).  It shouldn't
be much effort to forward-port it whern it comes to merge it.
