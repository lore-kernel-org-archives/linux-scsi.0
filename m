From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCHv2 6/6] cciss: Drop obsolete driver
Date: Mon, 14 Aug 2017 18:10:58 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8CE265@avsrvexchmbx2.microsemi.net>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
 <1502709555-15837-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:3508
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750965AbdHNSLm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 14:11:42 -0400
In-Reply-To: <1502709555-15837-7-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, August 14, 2017 6:19 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Don Brace
> <don.brace@microsemi.com>; Meelis Roos <mroos@linux.ee>; linux-
> scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de>; Hannes Reinecke
> <hare@suse.com>
> Subject: [PATCHv2 6/6] cciss: Drop obsolete driver
>=20
> EXTERNAL EMAIL
>=20
>=20
> The hpsa driver now has support for all boards the cciss driver
> used to support, so this patch removes the cciss driver and
> make hpsa an alias to cciss.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: Don Brace <don.brace@microsemi.com>
> ---
>  Documentation/blockdev/cciss.txt |  194 --
>  MAINTAINERS                      |   10 -
>  drivers/block/Kconfig            |   27 -
>  drivers/block/Makefile           |    1 -
>  drivers/block/cciss.c            | 5415 --------------------------------=
------
>  drivers/block/cciss.h            |  433 ---
>  drivers/block/cciss_cmd.h        |  269 --
>  drivers/block/cciss_scsi.c       | 1653 ------------
>  drivers/block/cciss_scsi.h       |   79 -
>  drivers/scsi/hpsa.c              |    1 +
>  10 files changed, 1 insertion(+), 8081 deletions(-)
>  delete mode 100644 Documentation/blockdev/cciss.txt
>  delete mode 100644 drivers/block/cciss.c
>  delete mode 100644 drivers/block/cciss.h
>  delete mode 100644 drivers/block/cciss_cmd.h
>  delete mode 100644 drivers/block/cciss_scsi.c
>  delete mode 100644 drivers/block/cciss_scsi.h
>=20
Acked-by: Don Brace <don.brace@microsemi.com>
