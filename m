From: Aaron Lu <aaron.lu@amd.com>
Subject: [RFC]pass pm related information from ata to scsi
Date: Mon, 14 May 2012 18:02:07 +0800
Message-ID: <20120514100206.GA3006@localhost.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux pm mailing list <linux-pm@vger.kernel.org>, linux scsi mailing list <linux-scsi@vger.kernel.org>, linux ide mailing list <linux-ide@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

ATA ODD has a new feature called device attention, which means it can
notify sata host that it needs power when in powered off state.

In libata, we can set a flag(ATA_DFLAG_DA) to represent this when
identifying the ata device. And when we are going to create the scsi
device(in ata_scsi_scan_host by __scsi_add_device), I hope the scsi
driver(sr) knows that this ODD supports device attention in its probe
function(sr_probe).

I didn't find a proper way to do this, any suggestions?
Thanks.

