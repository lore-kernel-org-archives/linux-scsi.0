From: =?UTF-8?B?SMOla29uIEzDuHZkYWw=?= <hlovdal@gmail.com>
Subject: Re: [PATCH 2/3] libata: Bind the Linux device tree to the ACPI device
	tree
Date: Thu, 6 Aug 2009 08:54:31 +0200
Message-ID: <a01a16b50908052354h28522bafja255c4fcac9a2ea8@mail.gmail.com>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
	 <1247518987-10818-2-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1247518987-10818-2-git-send-email-mjg@redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, shaohua.li@intel.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2009/7/13 Matthew Garrett <mjg@redhat.com>:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sata_pmp_atta=
ched(ap))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 adr =3D SATA_ADR(ap->port_no, NO_PORT_MULT);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 adr =3D SATA_ADR(ap->port_no, dev->link->pmp);

Maybe I am missing something, but wouldn't it be more natural to write =
this as

        if (sata_pmp_attached(ap))
                adr =3D SATA_ADR(ap->port_no, dev->link->pmp);
        else
                adr =3D SATA_ADR(ap->port_no, NO_PORT_MULT);

BR H=C3=A5kon L=C3=B8vdal
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
