From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas, lldds: Use dev_is_expander()
Date: Thu, 06 Jun 2019 18:02:14 -0400
Message-ID: <yq1k1dymkyh.fsf@oracle.com>
References: <1559751143-168560-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559751143-168560-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 6 Jun 2019 00:12:23 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jinpu.wang@profitbricks.com, lindar_liu@usish.com, yanaijie@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org


John,

> Many times in libsas, and in LLDDs which use libsas, the check for an
> expander device is re-implemented or open coded.

Applied to 5.3/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
