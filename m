From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 3/3] scsi: aacraid: Auto detect INTx or MSIx mode during
 sync cmd processing
Date: Mon, 29 Jan 2018 16:39:56 +0000
Message-ID: <8b1b447a100a4e929dab67e3c6e8dc13@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
 <20180120010157.22674-4-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0066.outbound.protection.outlook.com ([104.47.40.66]:42752
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751212AbeA2QkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 11:40:13 -0500
In-Reply-To: <20180120010157.22674-4-RaghavaAditya.Renukunta@microsemi.com>
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
> Subject: [PATCH 3/3] scsi: aacraid: Auto detect INTx or MSIx mode during =
sync
> cmd processing
>=20
> During sync command processing if legacy INTx status indicates
> command is not completed, sample the MSIx register and check if
> it indicates command completion, set controller MSIx enabled flag.
>=20
> Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
