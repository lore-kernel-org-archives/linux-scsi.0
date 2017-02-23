From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sense handling improvements
Date: Thu, 23 Feb 2017 09:28:20 -0500
Message-ID: <yq1efyp6kxn.fsf@oracle.com>
References: <20170214191600.17480-1-hch@lst.de> <yq18tp6by2n.fsf@oracle.com>
        <20170222071915.GA18084@lst.de> <yq1shn57mqn.fsf@oracle.com>
        <20170223094948.GA29551@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170223094948.GA29551@lst.de> (Christoph Hellwig's message of
        "Thu, 23 Feb 2017 10:49:48 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph,

>> I applied 1-4 to 4.11/scsi-fixes. Both 5 and 6 had problems so please
>> fix those up.

Christoph> What kind of problem?  I didn't see anything on the list.

They didn't apply. I tried to fix them up by hand. 5 was easy but 6
caused a flurry of failures that I ran out of time to look into.

So please resubmit 5 and 6 against 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
