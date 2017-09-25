From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: remove redundant copy_from_user in _ctl_getiocinfo
Date: Mon, 25 Sep 2017 19:22:35 -0400
Message-ID: <yq160c6e538.fsf@oracle.com>
References: <1505920431-13173-1-git-send-email-mengxu.gatech@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505920431-13173-1-git-send-email-mengxu.gatech@gmail.com> (Meng
        Xu's message of "Wed, 20 Sep 2017 11:13:51 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Meng Xu <mengxu.gatech@gmail.com>
Cc: hch@infradead.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org


Meng,

> Since right after the user copy, we are going to
> memset(&karg, 0, sizeof(karg)), the copy_from_user is redundant

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
