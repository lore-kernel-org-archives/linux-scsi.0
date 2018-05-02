From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: remove redundant check on in_connection_align_insertion_frequency
Date: Tue, 01 May 2018 23:32:08 -0400
Message-ID: <yq14ljq7mx3.fsf@oracle.com>
References: <20180425105843.8607-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425105843.8607-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 25 Apr 2018 11:58:43 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The sanity check on u->in_connection_align_insertion_frequency is
> being performed twice and hence the first check can be removed since
> it is redundant. Cleans up cppcheck warning:
>
> drivers/scsi/ibmvscsi/ibmvscsi.c:1711: (warning) Identical inner 'if'
> condition is always true.

Applied to 4.18/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
