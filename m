From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] libata: Bind the Linux device tree to the ACPI
	device tree
Date: Thu, 6 Aug 2009 15:51:25 +0100
Message-ID: <20090806145125.GB3181@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com> <1247518987-10818-2-git-send-email-mjg@redhat.com> <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon_L=F8vdal?= <hlovdal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, shaohua.li@intel.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2009 at 08:54:31AM +0200, H=E5kon L=F8vdal wrote:
> Maybe I am missing something, but wouldn't it be more natural to writ=
e this as
>=20
>         if (sata_pmp_attached(ap))
>                 adr =3D SATA_ADR(ap->port_no, dev->link->pmp);
>         else
>                 adr =3D SATA_ADR(ap->port_no, NO_PORT_MULT);

Heh, yes. That would also work.

--=20
Matthew Garrett | mjg59@srcf.ucam.org
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
