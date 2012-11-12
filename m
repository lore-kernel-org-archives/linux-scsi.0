From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 12 Nov 2012 14:18:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211121417230.31816-100000@netrider.rowland.org>
References: <20121112191440.GF5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121112191440.GF5560@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 12 Nov 2012, Tejun Heo wrote:

> On Fri, Nov 09, 2012 at 02:51:59PM +0800, Aaron Lu wrote:
> > A new interface to block disk events is added, this interface is
> > meant to eliminate a race between PM runtime callback and disk events
> > checking.
> > 
> > Suppose the following device tree:
> > device_sata_port  (the parent)
> >   device_ODD      (the child)
> 
> Weren't you gonna do something different about this?  I mean, if sr
> knows that autopm kicked in, it can simply tell the block layer that
> nothing is going on.  Wouldn't that be simpler?

It wouldn't work for non-ZP drives.  They do need to be polled, even 
when suspended.

Alan Stern

