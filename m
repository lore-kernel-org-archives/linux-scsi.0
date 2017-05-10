From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH V2 01/19] aacraid: Remove __GFP_DMA for raw srb memory
Date: Wed, 10 May 2017 15:36:42 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5260B98C@avsrvexchmbx2.microsemi.net>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
 <1494434393-17261-2-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0046.outbound.protection.outlook.com ([104.47.37.46]:24045
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753209AbdEJPg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 11:36:59 -0400
In-Reply-To: <1494434393-17261-2-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
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
> Subject: [PATCH V2 01/19] aacraid: Remove __GFP_DMA for raw srb memory
>=20
> The raw srb commands do not requires memory that in the ZONE_DMA memory
> space. For 32bit srb commands use GFP_DMA32 to limit the memory to 32bit
> memory range (4GB).
>=20
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
>=20
> ---
> Changes in V2:
> Corrected flag name to GFP_DMA32 in patch description and corrected
> GFP_DMA to __GFP_DMA in patch heading Removed comment
>=20
>  drivers/scsi/aacraid/commctrl.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
