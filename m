From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/20] [SCSI] mpt3sas: MPI 2.5 Rev I (2.5.4)
 specifications.
Date: Mon, 15 Jun 2015 11:51:48 +0200
Message-ID: <20150615095148.GB5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-6-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-6-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:17PM +0530, Sreekanth Reddy wrote:
> Update MPI 2.5 Release: MPI 2.5 Rev I (2.5.4) specification and 2.00.=
33 header files
>=20
> Below is the change set from the MPI specification for I Rev
>=20
> 1) Added Base Enclosure Level bit to the Flags field of Manufacturing=
 Page 7.
> 2) Updated description of the MaxTargetPortConnectTime field of SAS I=
O Unit Page 1.
> 3) Added EnclosureLevel and ConnectorName fields to SAS Device Page 0=
=2E Also, added EnclosureLevel and ConnectorName Valid bit to the Flags=
 field.
> 4) Added EnclosureLevel field to SAS Enclosure Page 0. Also, added En=
closureLevel Valid bit to the Flags field.
> 5) Added value for BIOS image to HashImageType.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpi/mpi2.h      |  6 ++++--
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 27 +++++++++++++++++++++-----=
-
>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |  4 +++-
>  3 files changed, 28 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/m=
pi/mpi2.h
> index c34c115..d730c5c 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
> @@ -8,7 +8,7 @@
>   *                 scatter/gather formats.
>   * Creation Date:  June 21, 2006
>   *
> - * mpi2.h Version:  02.00.31
> + * mpi2.h Version:  02.00.33
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -88,6 +88,8 @@
>   *                     Added MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET.
>   * 04-09-13  02.00.30  Bumped MPI2_HEADER_VERSION_UNIT.
>   * 04-17-13  02.00.31  Bumped MPI2_HEADER_VERSION_UNIT.
> + * 08-19-13  02.00.32  Bumped MPI2_HEADER_VERSION_UNIT.
> + * 12-05-13  02.00.33  Bumped MPI2_HEADER_VERSION_UNIT.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -121,7 +123,7 @@
>  #define MPI2_VERSION_02_05                  (0x0205)
> =20
>  /*Unit and Dev versioning for this MPI header set */
> -#define MPI2_HEADER_VERSION_UNIT            (0x1F)
> +#define MPI2_HEADER_VERSION_UNIT            (0x21)
>  #define MPI2_HEADER_VERSION_DEV             (0x00)
>  #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
>  #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3=
sas/mpi/mpi2_cnfg.h
> index e261a31..62dfbf6 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> @@ -6,7 +6,7 @@
>   *         Title:  MPI Configuration messages and pages
>   * Creation Date:  November 10, 2006
>   *
> - *   mpi2_cnfg.h Version:  02.00.26
> + *   mpi2_cnfg.h Version:  02.00.27
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -165,6 +165,16 @@
>   *                     match the specification.
>   * 08-19-13  02.00.26  Added reserved words to MPI2_CONFIG_PAGE_IO_U=
NIT_7 for
>   *			future use.
> + * 12-05-13  02.00.27  Added MPI2_MANPAGE7_FLAG_BASE_ENCLOSURE_LEVEL=
 for
> + *		       MPI2_CONFIG_PAGE_MAN_7.
> + *		       Added EnclosureLevel and ConnectorName fields to
> + *		       MPI2_CONFIG_PAGE_SAS_DEV_0.
> + *		       Added MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID for
> + *		       MPI2_CONFIG_PAGE_SAS_DEV_0.
> + *		       Added EnclosureLevel field to
> + *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
> + *		       Added MPI2_SAS_ENCLS0_FLAGS_ENCL_LEVEL_VALID for
> + *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -724,6 +734,7 @@ typedef struct _MPI2_CONFIG_PAGE_MAN_7 {
>  #define MPI2_MANUFACTURING7_PAGEVERSION                 (0x01)
> =20
>  /*defines for the Flags field */
> +#define MPI2_MANPAGE7_FLAG_BASE_ENCLOSURE_LEVEL         (0x00000008)
>  #define MPI2_MANPAGE7_FLAG_EVENTREPLAY_SLOT_ORDER       (0x00000002)
>  #define MPI2_MANPAGE7_FLAG_USE_SLOT_INFO                (0x00000001)
> =20
> @@ -2633,9 +2644,9 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_0 {
>  	U8
>  		ControlGroup;           /*0x2E */
>  	U8
> -		Reserved1;              /*0x2F */
> +		EnclosureLevel;		/*0x2F */
>  	U32
> -		Reserved2;              /*0x30 */
> +		ConnectorName[4];	/*0x30 */
>  	U32
>  		Reserved3;              /*0x34 */
>  } MPI2_CONFIG_PAGE_SAS_DEV_0,
> @@ -2643,7 +2654,7 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_0 {
>  	Mpi2SasDevicePage0_t,
>  	*pMpi2SasDevicePage0_t;
> =20
> -#define MPI2_SASDEVICE0_PAGEVERSION         (0x08)
> +#define MPI2_SASDEVICE0_PAGEVERSION         (0x09)
> =20
>  /*values for SAS Device Page 0 AccessStatus field */
>  #define MPI2_SAS_DEVICE0_ASTATUS_NO_ERRORS                  (0x00)
> @@ -2683,6 +2694,7 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_DEV_0 {
>  #define MPI2_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED           (0x0020)
>  #define MPI2_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED           (0x0010)
>  #define MPI2_SAS_DEVICE0_FLAGS_PORT_SELECTOR_ATTACH         (0x0008)
> +#define MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID             (0x0002)
>  #define MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT               (0x0001)
> =20
> =20
> @@ -3019,8 +3031,10 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_ENCLOSURE=
_0 {
>  		NumSlots;                   /*0x18 */
>  	U16
>  		StartSlot;                  /*0x1A */
> -	U16
> +	U8
>  		Reserved2;                  /*0x1C */
> +	U8
> +		EnclosureLevel;		    /*0x1D */
>  	U16
>  		SEPDevHandle;               /*0x1E */
>  	U32
> @@ -3031,9 +3045,10 @@ typedef struct _MPI2_CONFIG_PAGE_SAS_ENCLOSURE=
_0 {
>  	*PTR_MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0,
>  	Mpi2SasEnclosurePage0_t, *pMpi2SasEnclosurePage0_t;
> =20
> -#define MPI2_SASENCLOSURE0_PAGEVERSION      (0x03)
> +#define MPI2_SASENCLOSURE0_PAGEVERSION      (0x04)
> =20
>  /*values for SAS Enclosure Page 0 Flags field */
> +#define MPI2_SAS_ENCLS0_FLAGS_ENCL_LEVEL_VALID      (0x0010)
>  #define MPI2_SAS_ENCLS0_FLAGS_MNG_MASK              (0x000F)
>  #define MPI2_SAS_ENCLS0_FLAGS_MNG_UNKNOWN           (0x0000)
>  #define MPI2_SAS_ENCLS0_FLAGS_MNG_IOC_SES           (0x0001)
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3s=
as/mpi/mpi2_ioc.h
> index 4908309..d7598cc 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
> @@ -6,7 +6,7 @@
>   *         Title:  MPI IOC, Port, Event, FW Download, and FW Upload =
messages
>   * Creation Date:  October 11, 2006
>   *
> - * mpi2_ioc.h Version:  02.00.23
> + * mpi2_ioc.h Version:  02.00.24
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -132,6 +132,7 @@
>   *			Added MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE.
>   *			Added MPI2_FW_DOWNLOAD_ITYPE_PUBLIC_KEY.
>   *			Added Encrypted Hash Extended Image.
> + * 12-05-13  02.00.24  Added MPI25_HASH_IMAGE_TYPE_BIOS.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -1598,6 +1599,7 @@ Mpi25EncryptedHashEntry_t, *pMpi25EncryptedHash=
Entry_t;
>  /* values for HashImageType */
>  #define MPI25_HASH_IMAGE_TYPE_UNUSED		(0x00)
>  #define MPI25_HASH_IMAGE_TYPE_FIRMWARE		(0x01)
> +#define MPI25_HASH_IMAGE_TYPE_BIOS              (0x02)
> =20
>  /* values for HashAlgorithm */
>  #define MPI25_HASH_ALGORITHM_UNUSED		(0x00)
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
