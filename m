From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Sat, 10 Apr 2004 23:14:08 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404102308270.6949-100000@poirot.grange>
References: <Pine.LNX.4.44.0404102112500.4100-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:18623 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262119AbUDJVPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 17:15:00 -0400
In-Reply-To: <Pine.LNX.4.44.0404102112500.4100-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 10 Apr 2004, Guennadi Liakhovetski wrote:

> Ok, sorry, forget (at least for now) about all that debugging I asked you
> about. Just tell me how much RAM you have. And, please, send me your
> complete dmesg from the start-up, and, maybe, related to your scsi-card.

I reviewed the dma-stuff in tmscsim, and so far I cannot see big problems
there, except if you have more than ~4GB RAM, or, at least, if you have
HIGHMEM64 set in your configuration. Looks like you are using a gentoo
kernel. Could you check in their configuration, if this option is set? If
you don't find the file itself, you might be lucky and find it in
/proc/config.gz. In any case, could you, please, try to enable DEBUG1,
i.e. in file drivers/scsi/tmscsim.c modify the line 178 (approx.) from
//#define DC390_DEBUG1
to
#define DC390_DEBUG1
. Recompile, and send the kernel messages.

Thanks
Guennadi
---
Guennadi Liakhovetski


