From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from
	NCR53c406a.c
Date: 07 Jul 2003 15:01:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057586512.2749.43.camel@dhcp22.swansea.linux.org.uk>
References: <20030707080051.AD4242C2C6@lists.samba.org>
	 <1057586204.1812.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:938
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S267017AbTGGNuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2003 09:50:07 -0400
In-Reply-To: <1057586204.1812.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Rusty Trivial Russell <rusty@rustcorp.com.au>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Llu, 2003-07-07 at 14:56, James Bottomley wrote:
> It's the old polling interface for the chip.  It was unplumbed when the
> ->command() API was removed, but these chips were strangely connected to
> soundblaster cards and may need to operate in no-interrupt mode (in
> which case we'll need to ressurect it).  I'm just waiting to see if
> anyone complains that their sound card attached CDROM no-longer works.

Non interrupt mode doesn't seem to need ->command(). The queue function
just happens to return when the I/O completes.

