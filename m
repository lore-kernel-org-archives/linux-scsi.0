From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Mon, 26 Nov 2012 11:21:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211261120190.2168-100000@iolanthe.rowland.org>
References: <1353935850.2523.52.camel@dabdike>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1353935850.2523.52.camel@dabdike>
Sender: linux-pm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 26 Nov 2012, James Bottomley wrote:

> I'm also curious about driving sleep from autopm, since mode page timers
> don't control the sleep transition.

Is it feasible to do this the other way around?  That is, to drive 
runtime suspend by noticing when the device decides to put itself into 
a low-power state?

Alan Stern

