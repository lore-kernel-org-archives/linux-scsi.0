From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 10:47:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209301044000.14373-100000@netrider.rowland.org>
References: <20120930123222.GA2412@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120930123222.GA2412@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 30 Sep 2012, Aaron Lu wrote:

> Makes sense to me, but there is a problem if I want to block events
> checking for the disk, as I do not have a pointer to the gendisk in ATA
> layer.

> The tray will be ejected by the ODD itself when it has power, I do not
> need to do that. Moreover, I don't think I need enable the GPE bit when
> it has power.

It sounds like you need to add only two things to the sr layer: An 
interface to enable/disable event checking and an interface to request 
an eject.  (And perhaps ejects can be carried out entirely within the 
ATAPI layer, with no need to involve sr.)

Alan Stern

