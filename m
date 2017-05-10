From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH V2 02/19] aacraid: Fix DMAR issues with  iommu=pt
Date: Wed, 10 May 2017 15:37:39 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5260B99D@avsrvexchmbx2.microsemi.net>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
 <1494434393-17261-3-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:54464
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753251AbdEJPh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 11:37:57 -0400
In-Reply-To: <1494434393-17261-3-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>

> -----Original Message-----
> From: Raghava Aditya Renukunta
> [mailto:RaghavaAditya.Renukunta@microsemi.com]
> Sent: Wednesday, May 10, 2017 10:40 AM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Dave Carroll <david.carroll@microsemi.com>; Gana Sridaran
> <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>; Prasad Munirathnam
> <Prasad.Munirathnam@microsemi.com>
> Subject: [PATCH V2 02/19] aacraid: Fix DMAR issues with iommu=3Dpt
>=20
> The driver changed the DMA consistent map after consistent memory was
> allocated, this invalidated the IOMMU identity mapping. The fix was to ma=
ke
> sure that we set the DMA consistent mask setting once depending on the
> controller card.
>=20
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
>=20
> ---
> Changes in V2:
> None
>=20
>  drivers/scsi/aacraid/aachba.c  | 17 ++++++-----------
> drivers/scsi/aacraid/commsup.c | 29 ++++++++++++++++++-----------
>  drivers/scsi/aacraid/linit.c   | 32 +++++++++++++++++++-------------
>  3 files changed, 43 insertions(+), 35 deletions(-)
>=20
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
