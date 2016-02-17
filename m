From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/7] ibmvscsi: Replace magic values in
 set_adpater_info() with defines
Date: Wed, 17 Feb 2016 09:05:36 +0100
Message-ID: <20160217080536.GJ18134@c203.arch.suse.de>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-4-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455295395.2396.22.camel@HansenPartnership.com>
 <56BE0D7D.3050703@linux.vnet.ibm.com>
 <yq1k2m4xclf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1k2m4xclf.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 16, 2016 at 10:03:24PM -0500, Martin K. Petersen wrote:
> >>>>> "Tyrel" =3D=3D Tyrel Datwyler <tyreld@linux.vnet.ibm.com> write=
s:
>=20
> >> Is there some reason you didn't carry the review tag over from thi=
s:
> >>=20
> >> http://mid.gmane.org/20160204084459.GW27969@c203.arch.suse.de
> >>=20
> >> ?
> >>=20
> >> James
>=20
> Tyrel> The patch is slightly changed from v1. A define for AIX os typ=
e
> Tyrel> was added as mentioned in the cover letter v2 changes, and I
> Tyrel> moved the defines to the mad_adapter_info_data structure aroun=
d
> Tyrel> the fields they apply.
>=20
> Johannes: Mind checking this out?

I'm sorry I though I already did.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

>=20
> https://patchwork.kernel.org/patch/8276101/
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
