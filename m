From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/8] scsi: hisi_sas: increase timer expire of internal
 abort task
Date: Tue, 6 Mar 2018 12:23:01 +0100
Message-ID: <3983d075-af2e-5c69-2708-51db8a6b79cb@suse.de>
References: <1520261330-204596-1-git-send-email-john.garry@huawei.com>
 <1520261330-204596-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520261330-204596-6-git-send-email-john.garry@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 03/05/2018 03:48 PM, John Garry wrote:
> From: Xiaofei Tan <tanxiaofei@huawei.com>
> 
> The current 110ms expiry time is not long enough for the internal
> abort task.
> 
> The reason is that the internal abort task could be blocked in HW
> if the HW is retrying to set up link. The internal abort task will
> be executed only when the retry process finished.
> 
Hmm. That sounds weird.
I would have expected that a link retrain will force a device reset,
after which no tasks should be active on the target.
Consequently the succeeding abort task will be a no-op.
Care to clarify?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
