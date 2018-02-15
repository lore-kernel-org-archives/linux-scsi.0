From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] megaraid_sas: Do not use 32-bit atomic request descriptor for Ventura controllers
Date: Thu, 15 Feb 2018 18:51:33 -0500
Message-ID: <yq1y3jtke0q.fsf@oracle.com>
References: <1518595852-1490-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1518595852-1490-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
        (Shivasharan S.'s message of "Wed, 14 Feb 2018 00:10:52 -0800")
Sender: stable-owner@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Shivasharan,

> Sending I/O through 32 bit descriptors to Ventura series of controller
> results in IO timeout on certain conditions.

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
