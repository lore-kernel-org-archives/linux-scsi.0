From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 00/11] ufs: sysfs: read-only access to device
Date: Thu, 15 Feb 2018 18:44:56 -0500
Message-ID: <yq17erdlsw7.fsf@oracle.com>
References: <1518696851-6730-1-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518696851-6730-1-git-send-email-stanislav.nijnikov@wdc.com>
        (Stanislav Nijnikov's message of "Thu, 15 Feb 2018 14:14:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jaegeuk@kernel.org, Bart.VanAssche@wdc.com, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org


Stanislav,

> This patch introduces sysfs entries that will provide read-only access to
> device management data that could be received with UFS query requests.
> User-space applications will be able to read UFS device descriptors,
> flags and attributes.

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
