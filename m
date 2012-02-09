From: Holger Macht <holger@homac.de>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Thu, 9 Feb 2012 08:33:45 +0100
Message-ID: <20120209073345.GA11121@homac.suse.de>
References: <20120120001817.GA27706@homac.suse.de>
 <CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSYhOTitPctsJOTKWN9HDt0VZpQe_-_a0LnLefVGxOJtXg@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Do 09. Feb - 14:46:11, Lin Ming wrote:
> On Fri, Jan 20, 2012 at 8:18 AM, Holger Macht <holger@homac.de> wrote=
:
> > Patches 2 through 5 are just a refresh of the patches from Matthew
> > Garrett sent to this list in September 2010 [1]:
> >
> > Patch 1 is a new patch incorporating the corrections from James
> > Bottomley. Patch 6, 7 and 8 make the whole patch set actually work =
on my
> > test hardware (Thinkpad x60/Thinkpad T60) by fixing minor issues an=
d
> > compensating changes after the first submission.
> >
> > All patches now contain the correct Signed-off-by instead of Acked-=
by
> > tags.
> >
> > =A0[PATCH 1/8] scsi: Add wrapper to access and set scsi_bus_type in=
 struct acpi_bus_type
> > =A0[PATCH 2/8] libata: Bind the Linux device tree to the ACPI devic=
e tree
> > =A0[PATCH 3/8] libata: Migrate ACPI code over to new bindings
> > =A0[PATCH 4/8] acpi: Add support for linking docks to the objects t=
hey contain
> > =A0[PATCH 5/8] libata: Add links between removable devices and dock=
s
> > =A0[PATCH 6/8] libata: Generate and pass correct acpi handles
> > =A0[PATCH 7/8] acpi: Prevent duplicate hotplug device registration =
on dock stations
> > =A0[PATCH 8/8] libata: Use correct PCI devices
>=20
> Hi Holger,
>=20
> What's the status of these patches?

They've been ACKed by both ACPI (Len Brown) and libata (James Bottomley=
)
people, so I guess they are good to go and I'm waiting for someone (Jef=
f
Garzik?) to pick them up.

Regards,
 Holger

=20
>=20
> Some of my patches also need ata device binded to ACPI handle.
> I hope these patches will be merged soon.
>=20
> Thanks for the great work.
>=20
> Regards,
> Lin Ming
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
