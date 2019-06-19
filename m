From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: libsas, lldds: Use dev_is_expander()
Date: Tue, 18 Jun 2019 20:56:03 -0400
Message-ID: <yq1sgs6xujg.fsf@oracle.com>
References: <1560170501-220025-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560170501-220025-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 10 Jun 2019 20:41:41 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org


John,

> Many times in libsas, and in LLDDs which use libsas, the check for an
> expander device is re-implemented or open coded.
>
> Use dev_is_expander() instead. We rename this from
> sas_dev_type_is_expander() to not spill so many lines in referencing.

Applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
