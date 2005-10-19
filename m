From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Wed, 19 Oct 2005 16:32:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510191627270.4439-100000@iolanthe.rowland.org>
References: <43505229.8010502@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48269 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751311AbVJSUcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 16:32:23 -0400
In-Reply-To: <43505229.8010502@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 15 Oct 2005, Douglas Gilbert wrote:

> Alan,
> In include/scsi/scsi_eh.h there are several helper functions
> to aid processing SCSI errors. This includes SCSI sense data
> descriptor format (which won't be needed for DVD/HD/BD for
> some time with a (2**32 * 2048) byte maximum using existing
> fixed sense data format). However there is
> scsi_get_sense_info_fld() to fetch the info field.
> 
> sd, st and sg have been converted to use these helpers,
> where appropriate.
> 
> MMC-4 does not mention that the valid bit needs to
> be set on a MEDIUM/HARDWARE error and I have seen
> real life examples of this. [So it's poorly defined
> if one gets a medium error on lba 0.] You may also like to
> consider deferred errors which can occur according to
> MMC-4.

I just read the scsi_get_sense_info_fld routine.  For fixed format data, 
it won't return anything if the Valid bit isn't set!

This makes it hard to adopt both your first two suggestions... :-)

Alan Stern

