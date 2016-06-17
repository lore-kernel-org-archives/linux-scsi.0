From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name,
 email)
Date: Thu, 16 Jun 2016 19:33:07 -0700
Message-ID: <1466130787.19647.100.camel@perches.com>
References: <57634CBD.8000402@vmware.com>
	 <CAGRGNgVK_xMmCQFHhhJ9E1frzTE--ivX1Po19O_qUjgYtuUK7A@mail.gmail.com>
	 <1466128907097.81812@vmware.com>
	 <CAGRGNgX=ec9m=zene34Lbp0Gn23jSjwyeqaGaG7jGYXnRy6hFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGRGNgX=ec9m=zene34Lbp0Gn23jSjwyeqaGaG7jGYXnRy6hFg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>, Arvind Kumar <arvindkumar@vmware.com>
Cc: Jim Gill <jgill@vmware.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-06-17 at 12:18 +1000, Julian Calaby wrote:
> ./scripts/get_maintainers.pl -f drivers/scsi/vmw_pvscsi.c

just fyi:  the script name is not plural

$ ./scripts/get_maintainer.pl=A0=A0-f drivers/scsi/vmw_pvscsi.c
Arvind Kumar <arvindkumar@vmware.com> (maintainer:VMware PVSCSI driver)
VMware PV-Drivers <pv-drivers@vmware.com> (maintainer:VMware PVSCSI dri=
ver)
"James E.J. Bottomley" <jejb@linux.vnet.ibm.com> (maintainer:SCSI SUBSY=
STEM)
"Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI SUBS=
YSTEM)
linux-scsi@vger.kernel.org (open list:VMware PVSCSI driver)
linux-kernel@vger.kernel.org (open list)

and another fyi:

get_maintainer.pl also has a rarely used "--file-emails" option to
scan for what appears to be email addresses in specific files.

$ ./scripts/get_maintainer.pl=A0=A0-f --file-emails drivers/scsi/vmw_pv=
scsi.c
Arvind Kumar <arvindkumar@vmware.com> (maintainer:VMware PVSCSI driver,=
in file)
VMware PV-Drivers <pv-drivers@vmware.com> (maintainer:VMware PVSCSI dri=
ver)
"James E.J. Bottomley" <jejb@linux.vnet.ibm.com> (maintainer:SCSI SUBSY=
STEM)
"Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI SUBS=
YSTEM)
linux-scsi@vger.kernel.org (open list:VMware PVSCSI driver)
linux-kernel@vger.kernel.org (open list)

note the "in file" after Arvind's name
