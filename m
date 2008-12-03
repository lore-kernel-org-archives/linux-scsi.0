From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Wed, 03 Dec 2008 12:00:38 -0600
Message-ID: <1228327238.5551.34.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812031243140.2518-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42268 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYLCSAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 13:00:37 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812031243140.2518-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2008-12-03 at 12:44 -0500, Alan Stern wrote:
> James:
> 
> There hasn't been any feedback on this patch:
> 
> 	http://marc.info/?l=linux-scsi&m=122513368301598&w=2
> 
> It was modified in the way you requested.  Does it need to be revised 
> any more?

Probably not.  I really dislike a check and retry on something which is
theoretically a legal return, but I suppose I can put it in and see if
anything breaks.

James


