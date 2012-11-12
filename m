From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 12 Nov 2012 14:34:01 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211121432050.31816-100000@netrider.rowland.org>
References: <20121112192102.GG5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121112192102.GG5560@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 12 Nov 2012, Tejun Heo wrote:

> Hello, Alan.
> 
> On Mon, Nov 12, 2012 at 02:18:11PM -0500, Alan Stern wrote:
> > > Weren't you gonna do something different about this?  I mean, if sr
> > > knows that autopm kicked in, it can simply tell the block layer that
> > > nothing is going on.  Wouldn't that be simpler?
> > 
> > It wouldn't work for non-ZP drives.  They do need to be polled, even 
> > when suspended.
> 
> Hmmm... a bit confused, what would autopm do for those non-ZP devices?
> Would it make any difference?

It wouldn't do anything for the device, but it would allow the device's
parent to go to low power in between polls.  That's why Aaron at one
point suggested lengthening the polling interval.

Alan Stern

