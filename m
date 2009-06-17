From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] driver core: remove unheeded warning about driver methods
Date: Wed, 17 Jun 2009 13:12:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906171311430.2820-100000@iolanthe.rowland.org>
References: <4A391909.2090609@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50410 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753526AbZFQRMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:12:45 -0400
In-Reply-To: <4A391909.2090609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Wed, 17 Jun 2009, Boaz Harrosh wrote:

> There was a proper and simple fix for that problem here:
> http://www.spinics.net/lists/kernel/msg860289.html
> 
> Hannes please re push this patch properly. We want it ;)

I have to agree; Hannes's patch is a lot better.  Send it in!

Alan Stern

