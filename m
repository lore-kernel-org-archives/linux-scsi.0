From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: Fixed expander hotplug for SMART family
Date: Thu, 23 Feb 2017 21:34:46 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF42BF3@avsrvexchmbx1.microsemi.net>
References: <20170222152313.11518-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0085.outbound.protection.outlook.com ([104.47.34.85]:51456
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751327AbdBWVet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 16:34:49 -0500
In-Reply-To: <20170222152313.11518-1-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

> -----Original Message-----
> From: Raghava Aditya Renukunta
> [mailto:RaghavaAditya.Renukunta@microsemi.com]
> Sent: Wednesday, February 22, 2017 8:23 AM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Dave Carroll; Gana Sridaran; Scott Benesh
> Subject: [PATCH] aacraid: Fixed expander hotplug for SMART family
>=20
> Current driver Hotplug processing code skips over Enclosure channel,
> therefore any addition/removal of expander enclosure is not processed.
> Additionally  device addition code relies on older device type, which
> prevents the hotplug of adapter expanders.
>=20
> Fixed by removing code that skips over Enclosure channels and using the
> latest device type for addition or removal or enclosure expanders.
>=20
> Fixes: 6223a39fe6fbbeef (scsi: aacraid: Added support for hotplug)
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
