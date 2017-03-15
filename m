From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: Fix potential null access
Date: Wed, 15 Mar 2017 22:23:47 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF66157@avsrvexchmbx1.microsemi.net>
References: <20170314162019.716-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:28973
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751867AbdCOWXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 18:23:53 -0400
In-Reply-To: <20170314162019.716-1-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Tomas Henzl <thezl@redhat.com>

> -----Original Message-----
> From: Raghava Aditya Renukunta
> [mailto:RaghavaAditya.Renukunta@microsemi.com]
> Sent: Tuesday, March 14, 2017 10:20 AM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Dave Carroll; Gana Sridaran; Scott Benesh; Tomas Henzl
> Subject: [PATCH] aacraid: Fix potential null access
>=20
> Currently command threads fails to return ioctls commands for older
> controller versions, since it returns when all the fibs have been allocat=
ed.
> Another issue is even all the fibs have not been allocated, the correct
> allocated fibs is not updated nor freed.
>=20
> Fixes: 113156bcea9ef1e6 (scsi: aacraid: Reworked aac_command_thread)
> Reported-by: Tomas Henzl <thezl@redhat.com>
>=20
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>=20
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
