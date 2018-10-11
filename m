From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] Neaten logging uses
Date: Wed, 10 Oct 2018 21:54:25 -0400
Message-ID: <yq1d0sh459q.fsf@oracle.com>
References: <cover.1537183087.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1537183087.git.joe@perches.com> (Joe Perches's message of
        "Mon, 17 Sep 2018 08:01:07 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Joe,

> Several defects exist in the logging uses
>
> o Missing KERN_<LEVEL>
> o Unnecessary KERN_<LEVEL> uses with panic
> o Mismatched MPT3SAS_FMT and %s: with name and __func__
>
> Correct these defects and perhaps add some clarity to the logging.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
