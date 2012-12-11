From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 10 Dec 2012 21:10:27 -0800
Message-ID: <20121211051027.GB1932@mtj.dyndns.org>
References: <1353906191.2523.25.camel@dabdike>
 <21511277.LLinyDpbAK@vostro.rjw.lan>
 <20121128013928.GB15971@htj.dyndns.org>
 <1354092969.2276.49.camel@dabdike>
 <20121203081321.GA9990@mint-spring.sh.intel.com>
 <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com>
 <20121203162323.GB19802@htj.dyndns.org>
 <1354623100.3206.34.camel@dabdike.int.hansenpartnership.com>
 <50C1891A.7040900@intel.com>
 <50C5564F.8030000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64735 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2LKFKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2012 00:10:34 -0500
Content-Disposition: inline
In-Reply-To: <50C5564F.8030000@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hello, guys.

On Mon, Dec 10, 2012 at 11:26:07AM +0800, Aaron Lu wrote:
> >>> The problem here is there's no easy to reach genhd from libata (or the
> >>> other way around) without going through sr.  I think we're gonna have
> >>> to have something in sr one way or the other.
> >>
> >> Can't we do that via an event? It's a bit clunky because we need the
> >> callback in the layer that sees the sdev, which is libata-scsi, we just
> >> need an analogue of ata_scsi_media_change_notify, but ignoring and
> >> allowing polling is essentially event driven as well, so it should all
> >> work.  We'll need a listener in genhd, which might be trickier.

I'm not really following what you mean.  Can you please elaborate?
One way or the other, doesn't the notification have to bubble up
through SCSI?

> A colleague of mine reminded me that it's impolite to write something
> like this, and here is my apology. I didn't mean to be rude, I'm sorry
> for this if it made you feel uncomfortable.

Oh, no, it's not rude at all.  I was just being distracted w/ other
stuff and lazy.  Sorry about that.

Thanks.

-- 
tejun
