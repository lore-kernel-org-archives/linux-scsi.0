From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedi: Fix a potential buffer overflow
Date: Mon, 30 Jul 2018 22:31:06 -0400
Message-ID: <yq1fu00w2z9.fsf@oracle.com>
References: <20180726211037.6257-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180726211037.6257-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Thu, 26 Jul 2018 14:10:37 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Tell snprintf() to store at most 255 characters in the output buffer
> instead of 256. This patch avoids that smatch reports the following
> warning:

Applied to 4.18/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
