From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from
	NCR53c406a.c
Date: 07 Jul 2003 08:56:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057586204.1812.2.camel@mulgrave>
References: <20030707080051.AD4242C2C6@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:39940 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264991AbTGGNmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2003 09:42:10 -0400
In-Reply-To: <20030707080051.AD4242C2C6@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Mon, 2003-07-07 at 02:46, Rusty Trivial Russell wrote:
> From:  Adrian Bunk <bunk@fs.tum.de>
> 
>   The patch below removes an unused function from 
>   drivers/scsi/NCR53c406a.c .
>    
>   I've tested the compilation with 2.5.72-mm2.

Rusty, I'm not going to remove this immediately.

It's the old polling interface for the chip.  It was unplumbed when the
->command() API was removed, but these chips were strangely connected to
soundblaster cards and may need to operate in no-interrupt mode (in
which case we'll need to ressurect it).  I'm just waiting to see if
anyone complains that their sound card attached CDROM no-longer works.

James


