From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: State of NCR53c7xx based drivers
Date: 23 Nov 2003 10:59:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069606797.2066.2.camel@mulgrave>
References: <20031122113834.GA8098@lst.de>
	<20031123175041.A1461@sygehus.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:16647 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262369AbTKWRAk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 12:00:40 -0500
In-Reply-To: <20031123175041.A1461@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-m68k@lists.linux-m68k.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-11-23 at 10:50, Rask Ingemann Lambertsen wrote:
> What about the 53c770? This chip is supported by 53c7xx, isn't it? But it
> seems as if 53c7xx uses the exact same code for both 53c710 and 53c770, so
> perhaps you can deal with that easily. Grep did not find any drivers that
> actually make use of the 53c770 support, although it is not unlikely that I
> might have missed something.

The driver for the 53c720 and 53c770 is the ncr53c8xx---I know, wrong
name, but it's had all the 8xx PCI guts removed.  It now handles the
53c720 chips in both the zalon (parisc based) and NCRQ720 (MCA based)
boards.  It should be fairly easy to use this for amiga stuff.  The
advantage is that it does drive the chip as a multi-threaded scripts
engine.

James


