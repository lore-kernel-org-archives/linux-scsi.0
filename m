From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic7xxx: aic7892(B): possible regression in 2.6.26:
	intermittent unexpected busfrees
Date: Wed, 30 Jul 2008 15:26:16 -0500
Message-ID: <1217449576.3335.42.camel@localhost.localdomain>
References: <488DC747.9060200@gmail.com>  <4890B218.3030009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55282 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbYG3U0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 16:26:18 -0400
In-Reply-To: <4890B218.3030009@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas.schorpp@gmail.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2008-07-30 at 20:25 +0200, thomas schorpp wrote:
> thomas schorpp wrote:
> > hi,
> > 
> > got dozens of intermittent bus-frees in few days with my Cheetah X15 
> > since upgrading to vanilla release kernel 2.6.26.0
> > 
> > -did not touch the hw
> > -fsck ok
> > -smart short/long selftest ok
> > -temperatures/voltages ok
> > 
> > is this the hot weather, my old adaptec 19160 hba or the on disc 
> > controller dying or have You guys done some "performance" changes in 
> > aic7xxx released with 2.6.26 ?
> 
> takeback. powerline voltage ribble by crappy REVOLTEC hdd fan cooler with broken 
> fan bearings after 3 months on the same line as the Cheetah.
> 
> greased, changed line and all fine again, sorry that is was not software ;)

It's a nice illustration of the problems hardware can cause on finicky
transmission lines that are SCSI buses.

Note, if the problems cause system failures (as in panics or causes
other problems ... well other problems than the usual ones caused when
the disk is lost or only intermittently accessible) then it would become
a software issue.

James


