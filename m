From: Jesper Juhl <juhl-lkml@dif.dk>
Subject: Re: Bug: audio playing broke with my SCSI CD and DVD drives in
 2.6.11-rc2-bk7 and beyond.
Date: Tue, 1 Feb 2005 00:53:03 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502010051350.2801@dragon.hygekrogen.localhost>
References: <Pine.LNX.4.62.0502010013470.3217@dragon.hygekrogen.localhost>
 <1107214648.4532.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dif.dk ([193.138.115.101]:30187 "EHLO mail.dif.dk")
	by vger.kernel.org with ESMTP id S261464AbVAaXti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 18:49:38 -0500
In-Reply-To: <1107214648.4532.33.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Mon, 31 Jan 2005, James Bottomley wrote:

> On Tue, 2005-02-01 at 00:22 +0100, Jesper Juhl wrote:
> > audio
> Could you try the attached?
> James
> 
I applied the patch to 2.6.11-rc2-bk9, rebuild, rebooted and now 
everything is just fine. 
Thank you.

-- 
Jesper Juhl


