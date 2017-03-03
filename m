From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: Fix typo in blink status
Date: Fri, 3 Mar 2017 18:34:31 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF53305@avsrvexchmbx1.microsemi.net>
References: <20170302172133.3503-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0057.outbound.protection.outlook.com ([104.47.33.57]:48480
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdCCSfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Mar 2017 13:35:19 -0500
In-Reply-To: <20170302172133.3503-1-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

> Subject: [PATCH] aacraid: Fix typo in blink status
>=20
> The return status of the adapter check on KERNEL_PANIC is supposed to be
> the upper 16 bits of the OMR status register.
>=20
> Fixes: c421530bf848604e (scsi: aacraid: Reorder Adpater status check)
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
