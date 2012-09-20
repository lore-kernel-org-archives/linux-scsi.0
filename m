From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Thu, 20 Sep 2012 16:54:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209201652230.1222-100000@iolanthe.rowland.org>
References: <201209202248.10613.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201209202248.10613.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 20 Sep 2012, Rafael J. Wysocki wrote:

> On Wednesday, September 12, 2012, Aaron Lu wrote:
> > Place the ODD into runtime suspend state as soon as there is nobody
> > using it.
> 
> OK, so how is ODD related to the sr driver?

Aaron did not make it clear in this patch description, although it may 
have been mentioned in the overall 0/6 description.  "ODD" stands for 
"Optical Disc Drive" -- in other words, a CD or DVD drive.  Once you 
know this, the relation is clear: sr is the SCSI driver for CD/DVD 
drives.

Alan Stern

