From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:38:27 -0500
Message-ID: <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
	 <4469F9FB.7020807@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:34512 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932124AbWEPQjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:39:11 -0400
In-Reply-To: <4469F9FB.7020807@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

On Tue, 2006-05-16 at 12:12 -0400, Jeff Garzik wrote:
> Its an API-which-only-libata-uses that we're discussing.  And because 
> its moving to the block layer, its also a 
> temporary-API-which-only-libata-uses.

OK ... this may be the root of the problem.  I really would like libata
to migrate to being block only ... especially as PATA looks to be trying
to follow you into the SCSI subsystem.  However, this has been the
statement for the past two years (at least), and really, few
enhancements have been made to block that you need to make good on this.
I think one of the things we'll try to find time to do at the storage
summit is to take a hard look at block to see exactly what has to be
added to make libata solely dependent upon it.

However, the bottom line is that if you want to modify the *SCSI* API
then you follow the same process as everyone else  (i.e. demonstrate
justification and utility and worry about long lived maintainability of
the API).

James


