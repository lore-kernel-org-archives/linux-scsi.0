From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/4] scsi: hisi_sas: Add support for DIF feature for v3 hw
Date: Tue, 04 Dec 2018 21:14:43 -0500
Message-ID: <yq1k1kosorw.fsf@oracle.com>
References: <1543838994-30028-1-git-send-email-john.garry@huawei.com>
        <1543838994-30028-5-git-send-email-john.garry@huawei.com>
        <yq1ftveszew.fsf@oracle.com>
        <358aae82-394e-9df2-6b05-5af8e0f196b3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <358aae82-394e-9df2-6b05-5af8e0f196b3@huawei.com> (John Garry's
        message of "Tue, 4 Dec 2018 12:16:54 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org


John,

> Are you happy for us to make DIX support in this driver "hisi_sas DIX
> experimental" short term?

That's entirely your call, it's your driver/controller.  I just want the
experimental tag to be due to reasons on *your* end.

If it's reasons on my end they'll need to get fixed. We shouldn't have
drivers circumventing features because of bugs in the core block/SCSI
code...

-- 
Martin K. Petersen	Oracle Linux Engineering
