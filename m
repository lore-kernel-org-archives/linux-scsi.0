From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Comments about the __scsi_mode_sense() routine
Date: 17 Jul 2003 11:47:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058456873.2647.55.camel@mulgrave>
References: <Pine.LNX.4.44L0.0307171037470.750-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:24071 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271493AbTGQPdb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 11:33:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307171037470.750-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2003-07-17 at 10:50, Alan Stern wrote:
> James:
> 
> I've got some comments about your __scsi_mode_sense() routine in
> scsi_lib.c.  Some of these may be wrong, and I'd like to get the straight 
> story.
> 
> 	1.  The kerneldoc at the start describes the return value wrongly.  
> The actual return value is the request's result code; it has nothing to do 
> with header offsets.

Yes, changed the return convention but not the docbook.

> 	2.  According to my outdated SCSI documentation, the DBD bit
> should be set to 0 to allow block descriptors and 1 to forbid them.  This
> is contrary to the kerneldoc and also contrary to the use in
> sd_read_cache_type() in sd.c.

This was commented on a while ago.  Looks like I updated the docbook for
one routine but not the other.

James


