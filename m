From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Do not use 32-bit atomic request descriptor for Ventura controllers
Date: Tue, 13 Feb 2018 21:33:14 -0500
Message-ID: <yq1h8qkpafp.fsf@oracle.com>
References: <1518413940-1657-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1518413940-1657-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Sun, 11 Feb 2018 21:39:00 -0800")
Sender: stable-owner@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Shivasharan,

> Sending I/O through 32 bit descriptors to Ventura series of controller
> results in IO timeout on certain conditions.

Please address Tomas' and Hannes' comments and repost these two.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
