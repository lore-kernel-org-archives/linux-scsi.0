From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] SCSI: cleanup debugfs usage
Date: Tue, 29 Jan 2019 00:37:47 -0500
Message-ID: <yq1zhrkdnx0.fsf@oracle.com>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-1-gregkh@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Tue, 22 Jan 2019 16:08:59 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Greg,

> When calling debugfs code, there is no need to ever check the return
> value of the call, as no logic should ever change if a call works
> properly or not.  Fix up a bunch of x86-specific code to not care
> about the results of debugfs.

Applied to 5.1/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
