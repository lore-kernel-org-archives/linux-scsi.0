From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 23:24:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFFAD7A.3070103@pobox.com>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com> <20030629110205.A4728@one-eyed-alien.net> <3EFF2D45.1040203@pobox.com> <1056911816.10896.207.camel@mulgrave> <3EFF38DF.2030502@pobox.com> <20030629172341.C4728@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11425 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265766AbTF3DKs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 23:10:48 -0400
In-Reply-To: <20030629172341.C4728@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andries Brouwer <aebr@win.tue.nl>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Dharm wrote:
> On Sun, Jun 29, 2003 at 03:07:11PM -0400, Jeff Garzik wrote:
> 
>>sr.c is still hardcoded to use mode_sense_6...  even though it's been 
>>hardcoded to use read/write_10 for years :)
> 
> 
> James made a patch to fix this, which I intend to test today or tomorrow.


I just cloned scsi-misc-2.5 and saw it.  I'll do the same w/ atapi.

	Jeff



