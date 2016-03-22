From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Don't overreach ioc->reply_post[] during initialization
Date: Mon, 21 Mar 2016 20:29:57 -0400
Message-ID: <yq1io0f5p8a.fsf@sermon.lab.mkp.net>
References: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <df80b371ec5e56ecd65be161acdc34c0f2964d2e.1458327050.git.calvinowens@fb.com>
	(Calvin Owens's message of "Fri, 18 Mar 2016 12:45:42 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

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
