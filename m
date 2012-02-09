From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Thu, 9 Feb 2012 14:46:11 +0800
Message-ID: <CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com>
References: <20120120001817.GA27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48924 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2BIGqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 01:46:12 -0500
In-Reply-To: <20120120001817.GA27706@homac.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Holger Macht <holger@homac.de>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@redhat.com>

On Fri, Jan 20, 2012 at 8:18 AM, Holger Macht <holger@homac.de> wrote:
> Patches 2 through 5 are just a refresh of the patches from Matthew
> Garrett sent to this list in September 2010 [1]:
>
> Patch 1 is a new patch incorporating the corrections from James
> Bottomley. Patch 6, 7 and 8 make the whole patch set actually work on=
 my
> test hardware (Thinkpad x60/Thinkpad T60) by fixing minor issues and
> compensating changes after the first submission.
>
> All patches now contain the correct Signed-off-by instead of Acked-by
> tags.
>
> =A0[PATCH 1/8] scsi: Add wrapper to access and set scsi_bus_type in s=
truct acpi_bus_type
> =A0[PATCH 2/8] libata: Bind the Linux device tree to the ACPI device =
tree
> =A0[PATCH 3/8] libata: Migrate ACPI code over to new bindings
> =A0[PATCH 4/8] acpi: Add support for linking docks to the objects the=
y contain
> =A0[PATCH 5/8] libata: Add links between removable devices and docks
> =A0[PATCH 6/8] libata: Generate and pass correct acpi handles
> =A0[PATCH 7/8] acpi: Prevent duplicate hotplug device registration on=
 dock stations
> =A0[PATCH 8/8] libata: Use correct PCI devices

Hi Holger,

What's the status of these patches?

Some of my patches also need ata device binded to ACPI handle.
I hope these patches will be merged soon.

Thanks for the great work.

Regards,
Lin Ming
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
