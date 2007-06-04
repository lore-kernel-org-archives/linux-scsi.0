From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] m68k: Atari SCSI driver update_timeout removal
Date: Mon, 04 Jun 2007 09:52:16 -0500
Message-ID: <1180968737.3711.2.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0706031250190.9351@anakin>
	 <20070604072839.GA15390@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38714 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXFDOwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2007 10:52:20 -0400
In-Reply-To: <20070604072839.GA15390@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Mon, 2007-06-04 at 08:28 +0100, Christoph Hellwig wrote:
> On Sun, Jun 03, 2007 at 12:55:04PM +0200, Geert Uytterhoeven wrote:
> > From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> > 
> > Atari SCSI driver fixes: remove update_timeout kludge
> 
> Looks good. James, can you send this on for 2.6.22 so the accidentally
> added cludge doesn't end up in any release version?

Yes, sure ... I'm just preparing the -rc updates for SCSI now.

James


