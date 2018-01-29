From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 2/3] scsi: aacraid: Preserve MSIX mode in the OMR register
Date: Mon, 29 Jan 2018 16:35:07 +0000
Message-ID: <0e3ec4e97b7d43e9a9f55214598baf5d@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
 <20180120010157.22674-3-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0065.outbound.protection.outlook.com ([104.47.33.65]:5728
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751496AbeA2Qfb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:31 -0500
In-Reply-To: <20180120010157.22674-3-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Scott Benesh <scott.benesh@microsemi.com>, Tom White <tom.white@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

> -----Original Message-----
> From: Raghava Aditya Renukunta
> [mailto:RaghavaAditya.Renukunta@microsemi.com]
> Sent: Friday, January 19, 2018 6:02 PM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Scott Benesh <scott.benesh@microsemi.com>; Tom White
> <tom.white@microsemi.com>; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>; Guilherme G . Piccoli
> <gpiccoli@linux.vnet.ibm.com>; Bart Van Assche <Bart.VanAssche@wdc.com>
> Subject: [PATCH 2/3] scsi: aacraid: Preserve MSIX mode in the OMR registe=
r
>=20
> Preserve the current MSIX mode value in the OMR before rewriting the OMR =
to
> initiate the IOP or Soft Reset.
>=20
> Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/src.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
