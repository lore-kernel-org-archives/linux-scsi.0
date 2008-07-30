From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
	2.6.27-rc1
Date: Wed, 30 Jul 2008 09:55:22 -0500
Message-ID: <1217429722.3335.3.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0807301016010.2584-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51396 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYG3Oz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 10:55:26 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807301016010.2584-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>

On Wed, 2008-07-30 at 10:17 -0400, Alan Stern wrote:
> On Tue, 29 Jul 2008, Matthew Dharm wrote:
> 
> > Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
> > just become a sysfs parameter which defaults to the 'ignore' state...
> 
> We have to be careful; there definitely are devices out there which 
> need to use the Residue.

This is sort of a tradeoff ... there was one complaint I saw where a
device turned read only without the fix idenitifed in this report.
Devices broken by the fix are definitely crawling out of the woodwork
now.  Either this patch needs to be reverted or a new fix needs to be
applied soon (and to stable).

James


