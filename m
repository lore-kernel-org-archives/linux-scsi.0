From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/5] m68k 53c700 SCSI
Date: Tue, 19 Jun 2007 18:22:54 +0100
Message-ID: <20070619172254.GA461@infradead.org>
References: <20070617124704.800461751@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397AbXFSRW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 13:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20070617124704.800461751@mail.of.borg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org

On Sun, Jun 17, 2007 at 02:47:04PM +0200, Geert Uytterhoeven wrote:
> 	Hi James,
> 
> These patches add support for m68k to the 53c700 SCSI core and introduce new
> drivers for various m68k hardware using this 53c700 SCSI core, to replace the
> just removed drivers using the old 53c7xx SCSI core.
> 
>   [1] [PATCH] 53c700 scsi: m68k support for the 53c700 SCSI core
>   [2] [PATCH] 53c700 scsi: m68k BVME6000 NCR53C710 SCSI
>   [3] [PATCH] 53c700 scsi: m68k MVME16x NCR53C710 SCSI
>   [4] [PATCH] 53c700 scsi: Amiga 4000T NCR53c710 SCSI
>   [5] [PATCH] 53c700 scsi: Amiga Zorro NCR53c710 SCSI
> 
> Please apply for 2.6.23. Thx!

The patches all look very nice to me, thanks a lot.
