From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek
 ST2500, ST2510 and ST2530
Date: Wed, 26 Aug 2009 13:21:31 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474BFDF65@cosmail01.lsi.com>
References: <Pine.LNX.4.64.0908261411370.13027@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908261411370.13027@e-smith.charlieb.ott.istop.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

I have verified the VID/PID strings. They are fine..

Reviewed-by: Babu Moger <babu.moger@lsi.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Charlie Brady
> Sent: Wednesday, August 26, 2009 1:17 PM
> To: linux-scsi@vger.kernel.org; dm-devel@redhat.com
> Subject: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek ST2500,
> ST2510 and ST2530
>=20
>=20
> [Re-submit - ST2500 added.]
>=20
> These storage arrays can use RDAC when configured with 'linux' as the
> initiator.
>=20
> http://www.sun.com/storage/disk_systems/workgroup/2500/
> http://www.sun.com/storage/disk_systems/workgroup/2510/
> http://www.sun.com/storage/disk_systems/workgroup/2530/
>=20
> Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>
>=20
> --- linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25
> 14:56:42.000000000 -0400
> +++ linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c.sun	2009-
> 08-26 14:11:53.000000000 -0400
> @@ -628,6 +628,9 @@
>   	{"SGI", "IS"},
>   	{"STK", "OPENstorage D280"},
>   	{"SUN", "CSM200_R"},
> +	{"SUN", "LCSM100_I"},
> +	{"SUN", "LCSM100_S"},
> +	{"SUN", "LCSM100_E"},
>   	{"SUN", "LCSM100_F"},
>   	{"DELL", "MD3000"},
>   	{"DELL", "MD3000i"},
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
