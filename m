From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: sysfs: reworking of the rpm_lvl and spm_lvl entries
Date: Wed, 21 Mar 2018 21:23:43 -0400
Message-ID: <yq14ll8rjhc.fsf@oracle.com>
References: <1519901286-17496-1-git-send-email-stanislav.nijnikov@wdc.com>
        <1519901286-17496-2-git-send-email-stanislav.nijnikov@wdc.com>
        <fbea3b00-7497-cb3f-746f-65f793677568@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fbea3b00-7497-cb3f-746f-65f793677568@intel.com> (Adrian Hunter's
        message of "Fri, 16 Mar 2018 16:19:08 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, subhashj@codeaurora.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org


Adrian,

> On 01/03/18 12:48, Stanislav Nijnikov wrote:
>> Read from these files will return the integed value of the chosen power
>> management level now. Separate entries were added to show the target
>> UFS device and UIC link states. The description of the possible power
>> managements levels was added to the ABI file. The on-write behaviour of
>> these entries wasn't changed.
>> 
>> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
