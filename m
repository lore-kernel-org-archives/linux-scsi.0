From: Andre Tomt <lkml@tomt.net>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Thu, 04 Dec 2003 00:27:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1070494030.15415.111.camel@slurv.pasop.tomt.net>
References: <20031203204445.GA26987@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031203204445.GA26987@gtf.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-12-03 at 21:44, Jeff Garzik wrote:
> Intel ICH5
> ----------
> Summary:  No TCQ.  Looks like a PATA controller, but with a few added,
> non-standard SATA port controls.

<snip>

> Intel ICH6 ("AHCI")
> -------------------
> Summary:  Per-device queues, full SATA control including hotplug
> and PM.

Hi jeff! :)

One question - with "including hotplug", does that mean some set hotplug
standard? Reason I'm asking is, we have a few servers from SuperMicro,
with a ICH5R S-ATA controller that claims it's supporting hotplug, but
hotplug is not in your ICH5-summary.

PS, libata works great on those systems, good work!
