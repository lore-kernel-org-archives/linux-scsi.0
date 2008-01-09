From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Wed, 9 Jan 2008 12:22:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801091216400.2880-100000@iolanthe.rowland.org>
References: <200801091711.33394.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56204 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751065AbYAIRWw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 12:22:52 -0500
In-Reply-To: <200801091711.33394.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Wed, 9 Jan 2008, Oliver Neukum wrote:

> This has an interesting implication. As the storage driver can share
> a device with in principle any other usb driver, we must audit all usb
> drivers if we wish to adopt this patch.
> All a device's interfaces must be resumed when the storage interface
> is resumed. To resume a storage device no memory must be allocated
> because that could deadlock.

Maybe people shouldn't enable autosuspend for their swap device...

What happens during normal system resume if a driver (not just USB!)  
needs to allocate memory before the swap device has been resumed?

Alan Stern

