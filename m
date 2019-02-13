From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] scsi: hisi_sas: Add support for DIX feature for v3 hw
Date: Tue, 12 Feb 2019 22:01:46 -0500
Message-ID: <yq1a7j0tmqt.fsf@oracle.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
        <1549450376-114929-2-git-send-email-john.garry@huawei.com>
        <yq1zhr5vpos.fsf@oracle.com>
        <53c516cc-cce3-a3e1-718f-6fc465b6e401@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53c516cc-cce3-a3e1-718f-6fc465b6e401@hisilicon.com> (chenxiang's
        message of "Mon, 11 Feb 2019 19:36:01 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


chenxiang,

>>> +	if (prot_flags & SCSI_PROT_REF_CHECK)
>>> +		return T10_CHK_APP_TAG_MSK;

>> Polarity is a bit unclear here. Is this statement disabling checking of
>> the app tag?
>
> Yes, disabling checking of app tag.
> For here, 1'b0 presents the related byte in DIF will be checked, and
> 1'b1 presents the related byte in DIF will not be checked.

OK, thanks for the clarification!

-- 
Martin K. Petersen	Oracle Linux Engineering
