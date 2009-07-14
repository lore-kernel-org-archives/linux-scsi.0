From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and
 remove EXPERIMENTAL dependency, since udev depends on BSG.
Date: Tue, 14 Jul 2009 10:22:16 -0400
Message-ID: <1247581336.4310.60.camel@mulgrave.site>
References: <1247513973-24899-1-git-send-email-john@stoffel.org>
	 <19035.36432.181354.977939@stoffel.org>  <4A5C27D4.5040204@panasas.com>
	 <1247578141.4310.34.camel@mulgrave.site>  <4A5C923B.9090109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48016 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbZGNOWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2009 10:22:21 -0400
In-Reply-To: <4A5C923B.9090109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org

On Tue, 2009-07-14 at 17:12 +0300, Boaz Harrosh wrote:
> On 07/14/2009 04:29 PM, James Bottomley wrote:
> > On Tue, 2009-07-14 at 09:38 +0300, Boaz Harrosh wrote:
> >> On 07/13/2009 10:43 PM, John Stoffel wrote:
> >>>>>>>> "John" == John Stoffel <john@stoffel.org> writes:
> >>> Dammit, I messed up here sending this patch.  I've just edited the
> >>> subject line and re-sent it with a bit more description.  I think this
> >>> patch is perfectly good to go into 2.6.31 right now, esp since it's
> >>> not changing code, just whether the code is turned on by default from
> >>> now on.
> >>>
> >> I would like it if you'd also CC stable@kernel.org on this patch. As this
> >> condition is already true for distros in the field.
> > 
> > The stable tree is for bug *fixes*.   Moving an option out from under
> > experimental is basically an enhancement, even if it could be argued it
> > should have been done long ago.
> > 
> 
> wouldn't you consider it a bug if a low-level plumbing like Udev is shipped
> with hard dependency on it?

Sure .. file a bug with udev ...

The point is that if you use a feature marked "Experimental, do not use"
it's not a bug in the provider if you use it.

Arguably, all this really shows is that the distros ignore EXPERIMENTAL,
so it's not really serving a useful purpose in the kernel.

> if Udev was part of Kconfig it would have a "depend" on bsg. But because
> it's a different product it can only rely on defaults?

James


