From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: BusLogic: fix incorrect spelling of adatper_reset_req
Date: Fri, 21 Apr 2017 10:32:29 -0400
Message-ID: <yq1y3utltky.fsf@oracle.com>
References: <20170221162711.24694-1-colin.king@canonical.com>
        <5f14add6-e78f-9cc7-7f3a-e53fb9e2dd2d@gonehiking.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5f14add6-e78f-9cc7-7f3a-e53fb9e2dd2d@gonehiking.org> (Khalid
        Aziz's message of "Fri, 21 Apr 2017 08:24:27 -0600")
Sender: kernel-janitors-owner@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>
Cc: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Khalid,

>> trivial fix to spelling mistake, adatper_reset_req should be
>> adapter_reset_req.  Also break up very long seq_printf statement into
>> multiple lines.

Applied to 4.12/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
