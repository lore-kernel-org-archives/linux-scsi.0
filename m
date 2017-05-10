From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH V2 15/19] aacraid: Make sure ioctl returns on controller
 reset
Date: Wed, 10 May 2017 15:40:22 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5260B9BA@avsrvexchmbx2.microsemi.net>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
 <1494434393-17261-16-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0078.outbound.protection.outlook.com ([104.47.40.78]:7328
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753162AbdEJPk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 11:40:26 -0400
In-Reply-To: <1494434393-17261-16-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
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
> Subject: [PATCH V2 15/19] aacraid: Make sure ioctl returns on controller =
reset
>=20
> Made sure that ioctl commands return in case of a controller reset.
>=20
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
>=20
> ---
> Changes in V2:
> Removed incorrect up
> Cleared wait flag once event is received not before

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
