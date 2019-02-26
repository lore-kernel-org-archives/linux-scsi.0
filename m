From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: clean obsolete return values of eh_timed_out
Date: Tue, 26 Feb 2019 10:10:33 -0500
Message-ID: <yq17edmd1qu.fsf@oracle.com>
References: <1550385027-6217-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550385027-6217-1-git-send-email-avri.altman@wdc.com> (Avri
        Altman's message of "Sun, 17 Feb 2019 08:30:27 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Avri,

> Those are no longer in use since commit 242f9dcb8ba6
> ("block: unify request timeout handling").

Applied to 5.1/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
