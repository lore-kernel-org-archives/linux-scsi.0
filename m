From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Replace vmalloc + memset with vzalloc
Date: Tue, 30 Jul 2019 12:21:44 -0400
Message-ID: <yq1zhkvmr1j.fsf@oracle.com>
References: <20190718074518.16273-1-hslester96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718074518.16273-1-hslester96@gmail.com> (Chuhong Yuan's
        message of "Thu, 18 Jul 2019 15:45:18 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Chuhong Yuan <hslester96@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Chuhong,

> Use vzalloc instead of using vmalloc to allocate memory and then
> zeroing it with memset.  This simplifies the code.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
