From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/4] aic79xx: SLOWCRC fix
Date: Tue, 24 Jan 2006 11:51:16 +0100
Message-ID: <1138099877.2977.38.camel@laptopd505.fenrus.org>
References: <43D5F706.30009@suse.de>
	 <1138096403.2977.36.camel@laptopd505.fenrus.org> <43D5FA0F.6040901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38107 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030444AbWAXKvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 05:51:19 -0500
In-Reply-To: <43D5FA0F.6040901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-01-24 at 10:57 +0100, Hannes Reinecke wrote:
> Arjan van de Ven wrote:
> > On Tue, 2006-01-24 at 10:44 +0100, Hannes Reinecke wrote:
> >>  	/*
> >> +	 * Slow down our CRC interval to be
> >> +	 * compatible with packetized U320 devices
> >> +	 * that can't handle a CRC at full speed
> >> +	 */
> >> +	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
> >> +		con_opts |= ENSLOWCRC;
> >> +	}
> > 
> > since this seems to be a device quirk, shouldn't this just be part of
> > the scsi blacklist and have a quirk there? Maybe with a generic option
> > to trigger that quirk as well rather than a per driver module one...
> > 
> Errm.
> 
> blacklisting is for device only, not for HBAs, or?

yup

> This slowcrc is a fix for buggy adaptec hardware. Nothing to do with the
> devices connected to it...

ok I read the comments as applying to disks rather than hbas..


