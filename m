From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Tidy clocks list head usage
Date: Mon, 05 Jun 2017 20:57:38 -0400
Message-ID: <yq18tl6djb1.fsf@oracle.com>
References: <1496651815-13416-1-git-send-email-adrian.hunter@intel.com>
        <1496651815-13416-2-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496651815-13416-2-git-send-email-adrian.hunter@intel.com>
        (Adrian Hunter's message of "Mon, 5 Jun 2017 11:36:54 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org


Adrian,

> Move the initialization of clocks list head to ufshcd_alloc_host() so
> that every driver doesn't have to do it. Remove checks for the list
> head being NULL because that is not possible.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
