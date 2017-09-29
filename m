From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] scsi: sd: Do not override max_sectors_kb sysfs setting
Date: Fri, 29 Sep 2017 13:46:03 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195BDADA97@avsrvexchmbx2.microsemi.net>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
 <20170928013859.1214-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0080.outbound.protection.outlook.com ([104.47.37.80]:38432
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751975AbdI2NqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Sep 2017 09:46:08 -0400
In-Reply-To: <20170928013859.1214-1-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, September 27, 2017 8:39 PM
> To: linux-scsi@vger.kernel.org
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Subject: [PATCH] scsi: sd: Do not override max_sectors_kb sysfs setting
>=20
> EXTERNAL EMAIL
>=20
>=20
> A user may lower the max_sectors_kb setting in sysfs to accommodate
> certain workloads. Previously we would always set the max I/O size to
> either the block layer default or the optional preferred I/O size
> reported by the device.
>=20
> Keep the current heuristics for the initial setting of max_sectors_kb.
> For subsequent invocations, only update the current queue limit if it
> exceeds the capabilities of the hardware.
>=20
> Reported-by: Don Brace <don.brace@microsemi.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Tested-by: Don Brace <don.brace@microsemi.com>

Really appreciate your attention to this matter.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
