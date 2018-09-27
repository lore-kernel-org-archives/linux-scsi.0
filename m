From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix comment in MODULE_PARM_DESC in qla2xxx
Date: Thu, 27 Sep 2018 19:49:47 -0400
Message-ID: <yq1tvmabiw4.fsf@oracle.com>
References: <20180911094811.12681-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911094811.12681-1-standby24x7@gmail.com> (Masanari Iida's
        message of "Tue, 11 Sep 2018 18:48:11 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, himanshu.madhani@cavium.com, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Masanari,

> Default value of ql2xasynctmfenable for qla2xxx driver was set to 1 in
> commit 043dc1d7e8501.  But comment in MODULE_PARAM_DESC was not
> modified.

Applied to 4.20/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
