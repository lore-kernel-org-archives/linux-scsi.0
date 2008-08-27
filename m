From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 27 Aug 2008 09:33:46 -0500
Message-ID: <1219847626.3292.17.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0808271019450.2498-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55296 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679AbYH0Ods (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 10:33:48 -0400
In-Reply-To: <Pine.LNX.4.44L0.0808271019450.2498-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2008-08-27 at 10:21 -0400, Alan Stern wrote:
> On Tue, 26 Aug 2008, Antonio Ospite wrote:
> 
> > Hi,
> > 
> > is the fix going to be merged? I haven't seen it in rc4-git series.
> 
> Sorry, it slipped my mind.  I'll submit it shortly.  However it may not 
> be accepted right away, since it affects a very important and difficult 
> part of the SCSI stack.

Um, it was my impression that the failure to retry hang problem was, in
fact, fixed in USB by this:

commit 580da34847488b404218d1d7f53b156f245f5555
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Tue Aug 5 13:05:17 2008 -0400

    Fix USB storage hang on command abort

What bug is still manifesting with the last_sector_bug flag that still
needs fixing?

James


