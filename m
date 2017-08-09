From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Wed, 9 Aug 2017 22:08:27 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:9376
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752181AbdHIWId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 18:08:33 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, August 08, 2017 3:35 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Don Brace <don.brace@microsemi.com>; Christoph Hellwig
> <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Meelis Roos
> <mroos@linux.ee>; linux-scsi@vger.kernel.org; Hannes Reinecke
> <hare@suse.de>
> Subject: [PATCH RESEND 0/6] hpsa: support legacy boards
>=20
> EXTERNAL EMAIL
>=20
>=20
> (Resend to include linux-scsi)
>=20
> Hi all,
>=20
> this patch adds support for legacy boards, ie for boards previously
> supported by cciss only.
> With this patchset the hpsa driver should work with all Smart Array
> boards if the 'hpsa_allow_any' module option is set, rendering the
> cciss driver obsolete.
>=20
> Hannes Reinecke (5):
>   hpsa: consolidate status variables
>   hpsa: add support for legacy boards
>   hpsa: disable volume status check for older controller
>   hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
>   hpsa: do not print errors for unsupported report luns format
>=20
> Jeff Mahoney (1):
>   hpsa: handle unsupported devices more gracefully
>=20
>  drivers/scsi/hpsa.c | 131
> ++++++++++++++++++++++++++++++++++++++++++++--------
>  drivers/scsi/hpsa.h |  57 ++++++++++++++++++++---
>  2 files changed, 162 insertions(+), 26 deletions(-)
>=20
> --
> 1.8.5.6

NACK this series

We do not want to support these older controllers in the hpsa driver.

While the driver may load and manage requests under healthy conditions
many features will not be supported. Customers will not have support
for any issues involving these controllers.

We would need to track these changes in our OOB driver adding
more confusion.

For more information please see:
http://cciss.sourceforge.net


Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
