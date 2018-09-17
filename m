From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: make sysfs error messages ratelimited
Date: Mon, 17 Sep 2018 02:48:20 -0400
Message-ID: <yq1fty8sjpn.fsf@oracle.com>
References: <20180907103924.17598-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907103924.17598-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 7 Sep 2018 11:39:24 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> It is possible to heavily spam the kernel logs with messages by
> excessive reading of the mpt3sas sysfs files.  Make the error messages
> ratelimited to reduce the spamming effect.

That's a bug. Please just nuke all of these.

-- 
Martin K. Petersen	Oracle Linux Engineering
