From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name,
 email)
Date: Thu, 16 Jun 2016 20:04:48 -0700
Message-ID: <1466132688.19647.105.camel@perches.com>
References: <57634CBD.8000402@vmware.com>
	 <CAGRGNgVK_xMmCQFHhhJ9E1frzTE--ivX1Po19O_qUjgYtuUK7A@mail.gmail.com>
	 <1466128907097.81812@vmware.com>
	 <CAGRGNgX=ec9m=zene34Lbp0Gn23jSjwyeqaGaG7jGYXnRy6hFg@mail.gmail.com>
	 <1466130787.19647.100.camel@perches.com>
	 <CAGRGNgXAgxMn9ChiVvcw+02ugEEKZh7WtXt2dLU-TegM-0_qKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGRGNgXAgxMn9ChiVvcw+02ugEEKZh7WtXt2dLU-TegM-0_qKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>, Jim Gill <jgill@vmware.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-06-17 at 12:44 +1000, Julian Calaby wrote:
> Hi Joe,

rehi Julian.

> On Fri, Jun 17, 2016 at 12:33 PM, Joe Perches <joe@perches.com> wrote=
:
[]
> > get_maintainer.pl also has a rarely used "--file-emails" option to
> > scan for what appears to be email addresses in specific files.
> >=20
> > $ ./scripts/get_maintainer.pl=A0=A0-f --file-emails drivers/scsi/vm=
w_pvscsi.c
> > Arvind Kumar <arvindkumar@vmware.com> (maintainer:VMware PVSCSI dri=
ver,in file)
> > VMware PV-Drivers <pv-drivers@vmware.com> (maintainer:VMware PVSCSI=
 driver)
> > "James E.J. Bottomley" <jejb@linux.vnet.ibm.com> (maintainer:SCSI S=
UBSYSTEM)
> > "Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI =
SUBSYSTEM)
> > linux-scsi@vger.kernel.org (open list:VMware PVSCSI driver)
> > linux-kernel@vger.kernel.org (open list)
> >=20
> > note the "in file" after Arvind's name
> Didn't know this, however my point stands: the maintainer line in the
> file is redundant if we find maintainers through MAINTAINERS or the
> get_maintainer.pl script.

Yes, I'm not suggesting anything else. =A0Jim's name
should appear in the MAINTAINERS file somewhere.

The question to me is whether or not Jim Gill is
taking over the maintainership of the entire
VMware PVSCSI driver or just a few files of it.
