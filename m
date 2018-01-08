From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Fix a race condition between SPI domain validation and system suspend
Date: Mon, 08 Jan 2018 11:02:53 -0500
Message-ID: <yq1mv1opccy.fsf@oracle.com>
References: <20180105171909.11839-1-bart.vanassche@wdc.com>
        <20180105171909.11839-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20180105171909.11839-3-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Fri, 5 Jan 2018 09:19:09 -0800")
Sender: linux-pm-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Woody Suwalski <terraluna977@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org


Bart,

> Avoid that the following warning is reported when suspending a system
> that is using the mptspi driver:

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
