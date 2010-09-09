From: Anil kumar <anils_r@yahoo.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 9 Sep 2010 12:34:55 -0700 (PDT)
Message-ID: <198194.69355.qm@web32407.mail.mud.yahoo.com>
References: <yq1fwxjt5ir.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fwxjt5ir.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin,

Thanks. I will go thru the DIF document and code.=20

But I had a quick question, isn't that drive has to support "protection=
 enable" also. Also, does Controller FW need to do anything extra to se=
nd DIF block down to drive. Ideally we will be sending 512 byte blocks =
down to drive.

-Anil

--- On Thu, 9/9/10, Martin K. Petersen <martin.petersen@oracle.com> wro=
te:

> From: Martin K. Petersen <martin.petersen@oracle.com>
> Subject: Re: scsi_cmnd data_buffer checksum
> To: "Anil kumar" <anils_r@yahoo.com>
> Cc: "Christof Schmitt" <christof.schmitt@de.ibm.com>, linux-kernel@vg=
er.kernel.org, linux-scsi@vger.kernel.org
> Date: Thursday, September 9, 2010, 9:23 AM
> >>>>> "Anil" =3D=3D Anil
> kumar <anils_r@yahoo.com>
> writes:
>=20
> Anil> cmd-> write_buf =3D (u8
> *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
> Anil> memcpy(cmd->local_write_buf, cmd->write_buf,
> cmd->scsibufflen(scsi_cmnd));
>=20
> You need to walk the scatterlist.=A0 You can't assume
> that the pages are
> contiguous in memory.
>=20
> But why are you doing this checksumming stuff manually when
> the existing
> DIX/DIF code can do it for you?
>=20
> --=20
> Martin K. Petersen=A0=A0=A0 Oracle Linux
> Engineering
>=20


     =20
