From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6] (was: Re: [PATCH] Re: AMD 53c974 SCSI driver in
 2.6)
Date: Sun, 23 Nov 2003 00:23:11 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311220023170.2772-100000@poirot.grange>
References: <Pine.LNX.4.44.0311202354360.2876-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44950 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262838AbTKVX2u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 18:28:50 -0500
In-Reply-To: <Pine.LNX.4.44.0311202354360.2876-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Guennadi Liakhovetski <gl@dsa-ac.de>, Kurt Garloff <garloff@suse.de>, "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org

Ok, in a separate email, I am going to send a patch, fixing the SCSI
tmscsim driver for 2.6. I'll drop all CC:'s from that email, so that all
persons, listed in CC: don't get it (~80K) twice. This patch is a
combination of my original patch, modifications from Kurt Garloff, and my
latest fixes.

Some questions, though:
1) is the following a proper use of the API:

sg_dma_address(&pSRB->Segmentx) = pci_map_page(pdev,...);

? Doesn't look too good, but I haven't found anything better yet. This is
the mapping for the non-SG mode.

2) Is the following correct - it disappeared as a recult of the first 2
patches.

3) I am not at all convinced, that the current version of
dc390_restore_ptr is correct - I just don't quite understand what are the
conditions on entry and what has to be done there.

I've sent an earlier version of this patch to 2 persons, who have kindly
offered there help in testing it. They might want to update to this
version - it is cleaner, and point 2) above was not fixed (if this really
is a fix) there. Other testers are, certainly, welcome.

Thanks again to all for the help.

Regards
Guennadi
---
Guennadi Liakhovetski





