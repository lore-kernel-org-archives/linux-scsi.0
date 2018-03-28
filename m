From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: ufs: add trace event for ufs upiu
Date: Wed, 28 Mar 2018 18:03:28 -0400
Message-ID: <yq1tvszhn7z.fsf@oracle.com>
References: <1522230138-27674-1-git-send-email-ohad.sharabi@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522230138-27674-1-git-send-email-ohad.sharabi@sandisk.com>
        (Ohad Sharabi's message of "Wed, 28 Mar 2018 12:42:18 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Ohad Sharabi <ohad.sharabi@sandisk.com>
Cc: stanislav.nijnikov@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org


Ohad,

> Add UFS Protocol Information Units(upiu) trace events for ufs driver,
> used to trace various ufs transaction types- command, task-management
> and device management.  The trace-point format is generic and can be
> easily adapted to trace other upius if needed.  Currently tracing ufs
> transaction of type 'device management', which this patch introduce,
> cannot be obtained from any other trace.  Device management
> transactions are used for communication with the device such as
> reading and writing descriptor or attributes etc.

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
