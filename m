From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during initialization
Date: Wed, 23 Mar 2016 14:43:41 +0530
Message-ID: <a9f49808fa886cafa23b7590114c46b3@mail.gmail.com>
References: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
 <yq1io0f5p8a.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35003 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbcCWJNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 05:13:44 -0400
Received: by mail-yw0-f180.google.com with SMTP id g127so10973881ywf.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 02:13:43 -0700 (PDT)
In-Reply-To: <yq1io0f5p8a.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Hi,
 Please consider this patch as Ack-by: Chaitra P B
<chaitra.basappa@broadcom.com>

Thanks,
 Chaitra

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Tuesday, March 22, 2016 6:00 AM
To: Calvin Owens
Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen; MPT-FusionLinux.pdl@broadcom.com;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
kernel-team@fb.com; Sreekanth Reddy
Subject: Re: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during
initialization

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> In _base_make_ioc_operational(), we walk ioc->reply_queue_list
Calvin> and pull a pointer out of successive elements of
Calvin> ioc->reply_post[] for each entry in that list if RDPQ is
Calvin> enabled.

Calvin> Since the code pulls the pointer for the next iteration at the
Calvin> bottom of the loop, it triggers the a KASAN dump on the final
Calvin> iteration:

Broadcom folks, please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
