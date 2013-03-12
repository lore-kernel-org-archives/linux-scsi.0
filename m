From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Tue, 12 Mar 2013 11:08:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1303121107230.2153-100000@iolanthe.rowland.org>
References: <513E98A7.3040307@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <513E98A7.3040307@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Aaron Lu <aaron.lwe@gmail.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Mar 2013, Aaron Lu wrote:

> So ata_host_controller waits for all of the ata_ports, and the ata_port
> waits for both scsi_host and ata_link. scsi_host waits for scsi_target,
> and scsi_target waits for scsi_device. So if scsi_device is not done,
> ata_port will not start. Doesn't look like a problem to me.
> 
> And from the log:
> https://bugzilla.kernel.org/attachment.cgi?id=95101
> It also looks like the order is correct.

You could compare the PM debugging logs for an async suspend and a 
synchronous suspend.  There might be an obvious difference in the 
ordering that would explain the problem.

Alan Stern

