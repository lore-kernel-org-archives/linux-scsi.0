From: Jens Axboe <axboe@suse.de>
Subject: Re: [patch 23/28] scsi cd: VariRec, GigaRec and PowerRec as user
Date: Wed, 8 Mar 2006 16:15:35 +0100
Message-ID: <20060308151535.GU4595@suse.de>
References: <200603080816.k288GSQO002236@shell0.pdx.osdl.net> <1141830726.3194.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49506 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932065AbWCHPPy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 10:15:54 -0500
Content-Disposition: inline
In-Reply-To: <1141830726.3194.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, T.Maguin@web.de

On Wed, Mar 08 2006, James Bottomley wrote:
> On Wed, 2006-03-08 at 00:14 -0800, akpm@osdl.org wrote:
> > From: Thomas Maguin <T.Maguin@web.de>
> 
> > This patch allows normal users to eectute some Plextor drives
> > commands:
> > 
> > - Hide CD-R
> > - SingleSession
> > - SpeedRead
> > - PowerRec
> > - VariRec
> > - GigaRec
> > 
> 
> This one just isn't safe.  We can't add vendor specific commands to the
> permissions table because they mean different things to different
> vendors ... get mode on one could be halt and catch fire on another, so
> the whole concept of safety via command verification is lost.
> 
> I don't happen to believe in this type of command verification anyway,
> so I'd be perfectly happy to switch this over to a better facility (like
> capabilities), but while you're claiming to vet commands, you have to be
> logically correct (which means no vendor specific commands).

I have to agree, unfortunately... Perhaps this is some motivation to get
the fs permission table into the mainline kernel for 2.6.17. It's the
'cmdfilter' branch of the git block repo. Then we could finally get rid
of this ugly command table.

-- 
Jens Axboe

