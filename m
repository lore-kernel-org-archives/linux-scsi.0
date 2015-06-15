From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 09/20] [SCSI] mpt3sas: MPI 2.5 Rev J (2.5.5)
 specification and 2.00.34 header files
Date: Mon, 15 Jun 2015 11:53:12 +0200
Message-ID: <20150615095312.GE5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbbFOJxP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 05:53:15 -0400
Content-Disposition: inline
In-Reply-To: <1434102153-38581-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:21PM +0530, Sreekanth Reddy wrote:
> Following is the change set,
>=20
> 1. Added more defines for the BiosOptions field of MPI2_CONFIG_PAGE_B=
IOS_1.
> 2. Added MPI2_TOOLBOX_CLEAN_BIT26_PRODUCT_SPECIFIC definition.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpi/mpi2.h      |  5 +++--
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 14 ++++++++++++--
>  drivers/scsi/mpt3sas/mpi/mpi2_tool.h |  4 +++-
>  3 files changed, 18 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/m=
pi/mpi2.h
> index d730c5c..c2d127c 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
> @@ -8,7 +8,7 @@
>   *                 scatter/gather formats.
>   * Creation Date:  June 21, 2006
>   *
> - * mpi2.h Version:  02.00.33
> + * mpi2.h Version:  02.00.34
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -90,6 +90,7 @@
>   * 04-17-13  02.00.31  Bumped MPI2_HEADER_VERSION_UNIT.
>   * 08-19-13  02.00.32  Bumped MPI2_HEADER_VERSION_UNIT.
>   * 12-05-13  02.00.33  Bumped MPI2_HEADER_VERSION_UNIT.
> + * 01-08-14  02.00.34  Bumped MPI2_HEADER_VERSION_UNIT
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -123,7 +124,7 @@
>  #define MPI2_VERSION_02_05                  (0x0205)
> =20
>  /*Unit and Dev versioning for this MPI header set */
> -#define MPI2_HEADER_VERSION_UNIT            (0x21)
> +#define MPI2_HEADER_VERSION_UNIT            (0x22)
>  #define MPI2_HEADER_VERSION_DEV             (0x00)
>  #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
>  #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3=
sas/mpi/mpi2_cnfg.h
> index 62dfbf6..66f2cc1 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> @@ -6,7 +6,7 @@
>   *         Title:  MPI Configuration messages and pages
>   * Creation Date:  November 10, 2006
>   *
> - *   mpi2_cnfg.h Version:  02.00.27
> + *   mpi2_cnfg.h Version:  02.00.28
>   *
>   * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or =
Mpi25
>   *       prefix are for use only on MPI v2.5 products, and must not =
be used
> @@ -175,6 +175,8 @@
>   *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
>   *		       Added MPI2_SAS_ENCLS0_FLAGS_ENCL_LEVEL_VALID for
>   *		       MPI2_CONFIG_PAGE_SAS_ENCLOSURE_0.
> + * 01-08-14  02.00.28  Added more defines for the BiosOptions field =
of
> + *		       MPI2_CONFIG_PAGE_BIOS_1.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -1334,9 +1336,17 @@ typedef struct _MPI2_CONFIG_PAGE_BIOS_1 {
>  	*PTR_MPI2_CONFIG_PAGE_BIOS_1,
>  	Mpi2BiosPage1_t, *pMpi2BiosPage1_t;
> =20
> -#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x05)
> +#define MPI2_BIOSPAGE1_PAGEVERSION                      (0x06)
> =20
>  /*values for BIOS Page 1 BiosOptions field */
> +#define MPI2_BIOSPAGE1_OPTIONS_X86_DISABLE_BIOS		    (0x00000400)
> +
> +#define MPI2_BIOSPAGE1_OPTIONS_MASK_REGISTRATION_UEFI_BSD	(0x0000030=
0)
> +#define MPI2_BIOSPAGE1_OPTIONS_USE_BIT0_REGISTRATION_UEFI_BSD	(0x000=
00000)
> +#define MPI2_BIOSPAGE1_OPTIONS_FULL_REGISTRATION_UEFI_BSD	(0x0000010=
0)
> +#define MPI2_BIOSPAGE1_OPTIONS_ADAPTER_REGISTRATION_UEFI_BSD	(0x0000=
0200)
> +#define MPI2_BIOSPAGE1_OPTIONS_DISABLE_REGISTRATION_UEFI_BSD	(0x0000=
0300)
> +
>  #define MPI2_BIOSPAGE1_OPTIONS_MASK_OEM_ID                  (0x00000=
0F0)
>  #define MPI2_BIOSPAGE1_OPTIONS_LSI_OEM_ID                   (0x00000=
000)
> =20
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h b/drivers/scsi/mpt3=
sas/mpi/mpi2_tool.h
> index 904910d..1629e5b 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_tool.h
> @@ -6,7 +6,7 @@
>   *         Title:  MPI diagnostic tool structures and definitions
>   * Creation Date:  March 26, 2007
>   *
> - *   mpi2_tool.h Version:  02.00.11
> + *   mpi2_tool.h Version:  02.00.12
>   *
>   * Version History
>   * ---------------
> @@ -33,6 +33,7 @@
>   * 07-26-12  02.00.10  Modified MPI2_TOOLBOX_DIAGNOSTIC_CLI_REQUEST =
so that
>   *                     it uses MPI Chain SGE as well as MPI Simple S=
GE.
>   * 08-19-13  02.00.11  Added MPI2_TOOLBOX_TEXT_DISPLAY_TOOL and rela=
ted info.
> + * 01-08-14  02.00.12  Added MPI2_TOOLBOX_CLEAN_BIT26_PRODUCT_SPECIF=
IC.
>   * -----------------------------------------------------------------=
---------
>   */
> =20
> @@ -100,6 +101,7 @@ typedef struct _MPI2_TOOLBOX_CLEAN_REQUEST {
>  #define MPI2_TOOLBOX_CLEAN_OTHER_PERSIST_PAGES      (0x20000000)
>  #define MPI2_TOOLBOX_CLEAN_FW_CURRENT               (0x10000000)
>  #define MPI2_TOOLBOX_CLEAN_FW_BACKUP                (0x08000000)
> +#define MPI2_TOOLBOX_CLEAN_BIT26_PRODUCT_SPECIFIC   (0x04000000)
>  #define MPI2_TOOLBOX_CLEAN_MEGARAID                 (0x02000000)
>  #define MPI2_TOOLBOX_CLEAN_INITIALIZATION           (0x01000000)
>  #define MPI2_TOOLBOX_CLEAN_FLASH                    (0x00000004)
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
