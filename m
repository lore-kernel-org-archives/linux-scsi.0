From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix possible null-pointer dereferences in qla2x00_alloc_fcport()
Date: Tue, 30 Jul 2019 12:50:31 -0400
Message-ID: <yq1imrjmppk.fsf@oracle.com>
References: <20190729084451.29290-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729084451.29290-1-baijiaju1990@gmail.com> (Jia-Ju Bai's
        message of "Mon, 29 Jul 2019 16:44:51 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jia-Ju,

> In qla2x00_alloc_fcport(), fcport is assigned to NULL in the error
> handling code on line 4880:
>     fcport = NULL;

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
