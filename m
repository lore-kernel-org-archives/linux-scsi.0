From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Sat, 20 May 2006 08:51:01 -0500
Message-ID: <1148133061.3529.3.camel@mulgrave.il.steeleye.com>
References: <20051114224512.GF9905@mathom.us>
	 <20060323180909.GD15140@mathom.us>
	 <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
	 <20060324122715.GG15140@mathom.us>  <446EA4B5.2030507@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26776 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964858AbWETNvF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 09:51:05 -0400
In-Reply-To: <446EA4B5.2030507@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denny Page <denny@cococafe.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-05-19 at 22:10 -0700, Denny Page wrote:
> The problem that Michael describes appears to be identical to the
> problem
> that I had reported with the HP-460 tape drives.  Same 6.5 min period,
> fixed
> by echo 12.5 and validating.  Perhaps the problem is specific to the
> card
> rather than with the array and tape drive?
> 
> Setting the xfer speed in the bios does not appear to affect the
> result with
> the 2.6.16 kernel.

That's odd ... the code to recognise the BIOS settings went into 2.6.16.
What does /proc/scsi/aic79xx/<n> say?

James


> 

