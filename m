From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] SCSI: cleanups
Date: Mon, 28 Mar 2005 17:29:17 +0200
Message-ID: <1112023757.6003.27.camel@laptopd505.fenrus.org>
References: <20050327202139.GQ4285@stusta.de>
	 <1112023305.5531.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24461 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261907AbVC1P3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 10:29:23 -0500
In-Reply-To: <1112023305.5531.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Adrian Bunk <bunk@stusta.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2005-03-28 at 09:21 -0600, James Bottomley wrote:
\
> > - remove the following unused functions:
> >   - scsi.h: print_driverbyte
> >   - scsi.h: print_hostbyte
> > - #if 0 the following unused functions:
> >   - constants.c: scsi_print_hostbyte
> >   - constants.c: scsi_print_driverbyte
> 
> These are useful to those of us who debug drivers.

how about a CONFIG_SCSI_DRIVER_DEBUG ?



