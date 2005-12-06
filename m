From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: potential initialisation problem in the aic94xx
Date: Mon, 05 Dec 2005 23:22:13 -0500
Message-ID: <1133842933.3282.7.camel@mulgrave>
References: <1133214768.3325.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11443 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751634AbVLFEWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Dec 2005 23:22:18 -0500
In-Reply-To: <1133214768.3325.66.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-11-28 at 15:52 -0600, James Bottomley wrote:
> I'm not sure if this is a genuine problem, or I just happen to have a
> broken card:  Since the card is unusual in being keyed 3.3v only, I
> don't actually have any working x86 machine I can try it in.

OK, I am sure now.  I've found an x86_64 machine with 3.3v slots and
verified that this card does work.

Therefore, we have a serious bug in the aic94xx driver init code.  It's
clearly relying on something to set it up correctly in the BIOS rather
than doing everything in the driver init routine.  This means (unless
corrected) that the card will only work on x86 like platforms.

James


