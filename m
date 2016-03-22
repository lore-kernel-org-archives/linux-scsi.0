From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during initialization
Date: Tue, 22 Mar 2016 15:35:54 +0530
Message-ID: <6b3eaa260503810f0a436dff32fc5a5a@mail.gmail.com>
References: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
 <yq1io0f5p8a.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35181 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbcCVKF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 06:05:58 -0400
Received: by mail-yw0-f175.google.com with SMTP id g127so247468352ywf.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2016 03:05:57 -0700 (PDT)
In-Reply-To: <yq1io0f5p8a.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Martin,
 This patch is being reviewed , we shall get back with reviews by
tomorrow.

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
