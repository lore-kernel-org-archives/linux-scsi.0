From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 21:58:09 -0500
Message-ID: <yq1shnyzkfy.fsf@oracle.com>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Tue, 31 Jan 2017 16:57:21 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> this series gets rid of the cmd_type field in struct
Christoph> request and instead folds it into the REQ_OP* space.  This
Christoph> reduces the size of struct request, and leads to a single op
Christoph> namespace that drivers can easily switch on.

Very nice cleanup!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
