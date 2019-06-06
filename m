From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: libsas, lldds: Use dev_is_expander()
Date: Thu, 6 Jun 2019 09:34:56 +0800
Message-ID: <e8ad370e-6528-2ab1-5001-ab3fa4dc5ae8@huawei.com>
References: <1559751143-168560-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559751143-168560-1-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.ibm.com, martin.petersen@oracle.com, intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jinpu.wang@profitbricks.com, lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org



On 2019/6/6 0:12, John Garry wrote:
> Many times in libsas, and in LLDDs which use libsas, the check for an
> expander device is re-implemented or open coded.
> 
> Use dev_is_expander() instead. We rename this from
> sas_dev_type_is_expander() to not spill so many lines in referencing.
> 
> Signed-off-by: John Garry<john.garry@huawei.com>

Cannot agree more，

Reviewed-by: Jason Yan <yanaijie@huawei.com>
