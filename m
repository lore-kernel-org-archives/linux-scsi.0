From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4] scsi: ufs: Make sysfs attributes writable
Date: Tue, 4 Sep 2018 13:27:26 +0300
Message-ID: <8fd05b2d-fa48-78af-6f1c-7e485c1008f6@intel.com>
References: <20180808224454.243790-1-evgreen@chromium.org>
 <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6dd8a547-7260-09b8-9096-8a1564b08e70@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 22/08/18 14:00, Adrian Hunter wrote:
> On 09/08/18 01:44, Evan Green wrote:
>> This change makes the UFS controller's sysfs attributes writable, which
>> will enable users to provision unprovisioned UFS devices, or
>> re-provision unlocked UFS devices.
>>
>> Signed-off-by: Evan Green <evgreen@chromium.org>
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> 

This patch has my Ack and Reviewed-by: Stanislav Nijnikov, so can it be
queued for v4.20?  There is also Evan's "[PATCH] scsi: ufs: Make sysfs flags
writable"
