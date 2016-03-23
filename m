From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during initialization
Date: Wed, 23 Mar 2016 16:36:08 -0400
Message-ID: <yq1zitp0w5j.fsf@sermon.lab.mkp.net>
References: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23151 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbcCWUgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 16:36:21 -0400
In-Reply-To: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
	(Calvin Owens's message of "Fri, 18 Mar 2016 12:45:42 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> In _base_make_ioc_operational(), we walk ioc->reply_queue_list
Calvin> and pull a pointer out of successive elements of
Calvin> ioc->reply_post[] for each entry in that list if RDPQ is
Calvin> enabled.

Calvin> Since the code pulls the pointer for the next iteration at the
Calvin> bottom of the loop, it triggers the a KASAN dump on the final
Calvin> iteration:

Applied to 4.6/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
