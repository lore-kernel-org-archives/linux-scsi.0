From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Wed, 3 Dec 2008 13:18:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812031315490.2518-100000@iolanthe.rowland.org>
References: <1228327238.5551.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49444 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751558AbYLCSSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 13:18:09 -0500
In-Reply-To: <1228327238.5551.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 3 Dec 2008, James Bottomley wrote:

> On Wed, 2008-12-03 at 12:44 -0500, Alan Stern wrote:
> > James:
> > 
> > There hasn't been any feedback on this patch:
> > 
> > 	http://marc.info/?l=linux-scsi&m=122513368301598&w=2
> > 
> > It was modified in the way you requested.  Does it need to be revised 
> > any more?
> 
> Probably not.  I really dislike a check and retry on something which is
> theoretically a legal return, but I suppose I can put it in and see if
> anything breaks.

It's too bad that the scsi_execute_req() interface loses all 
information about how much data the device actually sent.  If that 
information were preserved then it wouldn't be necessary to rely on 
this not-quite-satisfactory sort of test.

Alan Stern

