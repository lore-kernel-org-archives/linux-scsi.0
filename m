From: Rasesh Mody <rmody@brocade.com>
Subject: RE: [PATCH 0/3] Update the driver version to 3.2.21.1
Date: Fri, 10 May 2013 10:03:22 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86B666C5F5FD@HQ1-EXCH01.corp.brocade.com>
References: <1368191841-22088-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:58725 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910Ab3EJRZ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 13:25:58 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r4AH2Nhk024674
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2013 10:03:26 -0700
Received: from hq1wp-exchub02.corp.brocade.com ([144.49.131.13])
	by mx0a-000f0801.pphosted.com with ESMTP id 1c8y1n05yj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2013 10:03:26 -0700
In-Reply-To: <1368191841-22088-1-git-send-email-vmohan@brocade.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vijay Mohan Guvva <vmohan@Brocade.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>, Anil Gurumurthy <agurumur@Brocade.com>

Vijay,

Although we intend to update the driver version to 3.2.21.1, patch 0 mentions version as v3.2.21.0. We may get away with it as it's a trivial miss, however we should take care of such things in future submissions.

Thanks
Rasesh


>-----Original Message-----
>From: Vijay Mohan Guvva
>Sent: Friday, May 10, 2013 6:17 AM
>To: james.bottomley@hansenpartnership.com
>Cc: linux-scsi@vger.kernel.org; Adapter Linux Open SRC Team; Anil
>Gurumurthy; Vijay Mohan Guvva
>Subject: [PATCH 0/3] Update the driver version to 3.2.21.1
>
>From: Vijaya Mohan Guvva <vmohan@brocade.com>
>
>Hi James,
> The following patch-set includes support for new hardware - chinook quad
>port card, path tov fix and updates the Brocade BFA driver to v3.2.21.0.
>
> I have compiled and tested the code against scsi-misc. Please review and
>provide your comments.
>
>Thanks,
>Vijaya Mohan Guvva
>
>Vijaya Mohan Guvva (3):
>  bfa: Support for chinook-quad port card
>  bfa: dis-associate bfa path_tov with dev_loss_tmo
>  bfa: Update the driver version to 3.2.21.1
>
> drivers/scsi/bfa/bfa_defs.h  |  5 ++++-
> drivers/scsi/bfa/bfa_ioc.c   |  1 +
> drivers/scsi/bfa/bfad.c      |  8 ++++++++
> drivers/scsi/bfa/bfad_attr.c | 33 +++++++--------------------------
>drivers/scsi/bfa/bfad_drv.h  |  2 +-
> 5 files changed, 21 insertions(+), 28 deletions(-)
>
>--
>1.8.2.1

