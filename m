From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6] (was: Re: [PATCH] Re: AMD 53c974 SCSI driver in
 2.6)
Date: Mon, 24 Nov 2003 21:18:43 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311242053330.2874-100000@poirot.grange>
References: <20031124074721.B29095@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:33247 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263918AbTKXUdi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 15:33:38 -0500
In-Reply-To: <20031124074721.B29095@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 24 Nov 2003, Christoph Hellwig wrote:

> On Sun, Nov 23, 2003 at 12:27:32AM +0100, Guennadi Liakhovetski wrote:
> > The appended patch is an attempt to fix the tmscsim driver for 2.6. Tested
> > only on an on-board AM53C974 controller so far.
>
> Patch looks good as far as I can see, of course there's lot of cleanup
> potential, but let's have a working driver in mainline first..

Thanks! I've got a few reports, saying that to apply the patch one needs
to use the '-l' option - looks like TABs got corrupted in my email somehow
(I am embarrassed...). To fix this I am attaching a bzip2-file, which,
hopefully, can't get corrupted, but I'm no longer sure about it - I had a
report, saying that this one had the same problem too... Anyway, I'll
receive a copy of it on linux-scsi and will be able to double-check it.
Just checked the file locally - applies cleanly to test10.

This new version also has one addition - call scsi_unregister() on module
cleanup (thanks to Thorsten Leemhuis for pointing this out). Otherwise the
patch was reported to work with a DC390 and as a module too (I only tested
it with AM53C974 compiled in).

Thanks
Guennadi
---
Guennadi Liakhovetski




