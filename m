From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC]pass pm related information from ata to scsi
Date: Mon, 14 May 2012 10:20:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205141019330.1699-100000@iolanthe.rowland.org>
References: <20120514100206.GA3006@localhost.amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120514100206.GA3006@localhost.amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux pm mailing list <linux-pm@vger.kernel.org>, linux scsi mailing list <linux-scsi@vger.kernel.org>, linux ide mailing list <linux-ide@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 14 May 2012, Aaron Lu wrote:

> Hi,
> 
> ATA ODD has a new feature called device attention, which means it can
> notify sata host that it needs power when in powered off state.
> 
> In libata, we can set a flag(ATA_DFLAG_DA) to represent this when
> identifying the ata device. And when we are going to create the scsi
> device(in ata_scsi_scan_host by __scsi_add_device), I hope the scsi
> driver(sr) knows that this ODD supports device attention in its probe
> function(sr_probe).
> 
> I didn't find a proper way to do this, any suggestions?

Add a corresponding flag to the scsi_cd structure, and set the flag in 
libata's slave_configure routine.

Alan Stern

