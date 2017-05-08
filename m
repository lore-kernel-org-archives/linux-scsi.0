From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 00/19] aacraid: Patchset with reset rework and misc fixes
Date: Mon, 8 May 2017 21:16:54 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81B2679F@avsrvexchmbx2.microsemi.net>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0053.outbound.protection.outlook.com ([104.47.32.53]:59188
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752897AbdEHVQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 May 2017 17:16:58 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>

Hi,

The patch set  has been sent twice. Please ignore the later sent/received  =
patch set.

I had sent the original patch set on Saturday, but I did not receive a conf=
irmation nor did any mailing list archive(http://marc.info/?l=3Dlinux-scsi)=
 pick them up  (should have waited).  The next day I resent the patch set a=
nd here we are.

Regards,
Raghava Aditya

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Raghava Aditya Renukunta
> Sent: Sunday, May 7, 2017 6:34 AM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; Prasad Munirathnam
> <Prasad.Munirathnam@microsemi.com>
> Subject: [PATCH 00/19] aacraid: Patchset with reset rework and misc fixes
>=20
> EXTERNAL EMAIL
>=20
>=20
> This patchset primarily focuses on tweaking and hardening the controller
> reset support for both ARC and HBA1000 devices. Now the driver can only
> reset the controller thru eh reset. Included a srb memory fix and pci
> dma allocation fix.
>=20
> Raghava Aditya Renukunta (19):
>  [SCSI] aacraid: Remove GFP_DMA for raw srb memory
>  [SCSI] aacraid: Fix DMAR issues with  iommu=3Dpt
>  [SCSI] aacraid: Added 32 and 64 queue depth for arc natives
>  [SCSI] aacraid: Set correct Queue Depth for HBA1000 RAW disks
>  [SCSI] aacraid: Remove reset support from check_health
>  [SCSI] aacraid: Change wait time for fib completion
>  [SCSI] aacraid: Log count info of scsi cmds before reset
>  [SCSI] aacraid: Print ctrl status before eh reset
>  [SCSI] aacraid: Using single reset mask for IOP reset
>  [SCSI] aacraid: Rework IOP reset
>  [SCSI] aacraid: Add periodic checks to see IOP reset status
>  [SCSI] aacraid: Rework SOFT reset code
>  [SCSI] aacraid: Rework aac_src_restart
>  [SCSI] aacraid: Use correct function to get ctrl health
>  [SCSI] aacraid: Make sure ioctl returns on controller reset
>  [SCSI] aacraid: Enable ctrl reset for both hba and arc
>  [SCSI] aacraid: Add reset debugging statements
>  [SCSI] aacraid: Remove reference to Series-9
>  [SCSI] aacraid: Update driver version to 50834
>=20
>  drivers/scsi/aacraid/aachba.c   |  17 ++-
>  drivers/scsi/aacraid/aacraid.h  |  22 +++-
>  drivers/scsi/aacraid/commctrl.c |  13 ++-
>  drivers/scsi/aacraid/comminit.c |  18 +---
>  drivers/scsi/aacraid/commsup.c  |  73 +++++++------
>  drivers/scsi/aacraid/linit.c    | 232 ++++++++++++++++++++++++----------=
----
> --
>  drivers/scsi/aacraid/src.c      | 136 +++++++++++++----------
>  7 files changed, 296 insertions(+), 215 deletions(-)
>=20
> --
> 2.7.4
