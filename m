From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: State of NCR53c7xx based drivers
Date: Sun, 23 Nov 2003 17:50:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123175041.A1461@sygehus.dk>
References: <20031122113834.GA8098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a144f4.albnxx15.adsl-dhcp.tele.dk ([80.161.68.244]:4 "EHLO
	0x50a144f4.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org with ESMTP
	id S262369AbTKWQur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 11:50:47 -0500
Content-Disposition: inline
In-Reply-To: <20031122113834.GA8098@lst.de>; from hch@lst.de on Sat, Nov 22, 2003 at 12:38:34PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

On Sat, Nov 22, 2003 at 12:38:34PM +0100, Christoph Hellwig wrote:

> what's the status of the 53c7xx based drivers, namely amiga7xx,
> mvme16x and bvme6000?  These are the last ones still using the
> old 53x7xx instead of the new 53c700 core which despite the
> name also handles 53c710 chips.

It might be a good idea to update the comments in the code to say so more
clearly. At least in 2.6.0-test8, only two changelog entries say so.

What about the 53c770? This chip is supported by 53c7xx, isn't it? But it
seems as if 53c7xx uses the exact same code for both 53c710 and 53c770, so
perhaps you can deal with that easily. Grep did not find any drivers that
actually make use of the 53c770 support, although it is not unlikely that I
might have missed something.

And while we are at amiga7xx and 53c770: There are Amiga SCSI host adapters
with the 53c770 (CyberStorm PPC/MkIII), although amiga7xx doesn't support
them. Why?

-- 
Regards,
Rask Ingemann Lambertsen
