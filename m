From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: 28 Sep 2004 10:05:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096380337.1717.4.camel@mulgrave>
References: <20040927061003.GA182890@sgi.com>
	<20040928075407.GA190115@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27085 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267759AbUI1OFr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:05:47 -0400
In-Reply-To: <20040928075407.GA190115@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, andrew.vasquez@qlogic.com

On Tue, 2004-09-28 at 03:54, Jeremy Higdon wrote:
> On Sun, Sep 26, 2004 at 11:10:03PM -0700, Jeremy Higdon wrote:
> > This patch is to QLA2xxx version 8.00.00b15-k, and it allows users
> > to override the default driver queue depth for a target by making
> > the queue_depth sysfs attribute writeable.
> > 
> > I based this on the code in the 53c700 driver.
> > 
> > Andrew, please apply if it looks correct to you and James.
> > 
> > Let me know if you'd like me to regenerate against a different qla2xxx
> > version.
> > 
> > thanks
> > 
> > Jeremy
> 
> Found a bug in the patch.  It returned an incorrect count if tagged_supported
> was not true.

I haven't had time to check yet, but I believe I remember queue depth
being also a parameter that has to be communicated to the card's
firmware for the sizing of an internal queue.  Could you check ... and
if that is the case, we'll have to communicate this change to the card
as well.

James


