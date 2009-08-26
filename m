From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek
	2510 and 2530
Date: Wed, 26 Aug 2009 12:01:16 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474BFDEFA@cosmail01.lsi.com>
References: <Pine.LNX.4.64.0908251534340.21130@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908251534340.21130@e-smith.charlieb.ott.istop.com>
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
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Charlie,

   Patch looks good. However, I am seeing one more in this series({"SUN",=
 "LCSM100_E"}). You can add this as well..

-Babu Moger

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Charlie Brady
> Sent: Tuesday, August 25, 2009 2:40 PM
> To: linux-scsi@vger.kernel.org; dm-devel@redhat.com
> Subject: [dm-devel] [PATCH] scsi_dh_rdac: Add support for Sun
> StorageTek 2510 and 2530
>=20
>=20
> Both these storage arrays can use RDAC when configured with 'linux' as
> the
> initiator.
>=20
> http://www.sun.com/storage/disk_systems/workgroup/2510/
> http://www.sun.com/storage/disk_systems/workgroup/2530/
>=20
> Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>
>=20
> --- linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25
> 14:56:42.000000000 -0400
> +++ linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c.sun	2009-
> 08-25 15:22:56.000000000 -0400
> @@ -628,6 +628,8 @@
>   	{"SGI", "IS"},
>   	{"STK", "OPENstorage D280"},
>   	{"SUN", "CSM200_R"},
> +	{"SUN", "LCSM100_I"},
> +	{"SUN", "LCSM100_S"},
>   	{"SUN", "LCSM100_F"},
>   	{"DELL", "MD3000"},
>   	{"DELL", "MD3000i"},
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
