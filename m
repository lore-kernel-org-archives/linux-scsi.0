From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 23:39:52 +0800
Message-ID: <506867C8.4000301@intel.com>
References: <Pine.LNX.4.44L0.1209301044000.14373-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2I3PkM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2012 11:40:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209301044000.14373-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On 09/30/2012 10:47 PM, Alan Stern wrote:
> On Sun, 30 Sep 2012, Aaron Lu wrote:
> 
>> Makes sense to me, but there is a problem if I want to block events
>> checking for the disk, as I do not have a pointer to the gendisk in ATA
>> layer.
> 
>> The tray will be ejected by the ODD itself when it has power, I do not
>> need to do that. Moreover, I don't think I need enable the GPE bit when
>> it has power.
> 
> It sounds like you need to add only two things to the sr layer: An 
> interface to enable/disable event checking and an interface to request 
> an eject.  (And perhaps ejects can be carried out entirely within the 
> ATAPI layer, with no need to involve sr.)

Thanks for the suggestion, I'll try to do this.

-Aaron

