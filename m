From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [v2] sbitmap, scsi/target: add seq_file forward declaration
Date: Tue, 10 Jul 2018 22:54:55 -0400
Message-ID: <yq1in5mo51c.fsf@oracle.com>
References: <20180706201920.2185565-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706201920.2185565-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 6 Jul 2018 22:19:07 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Felipe Balbi <felipe.balbi@linux.intel.com>, Matthew Wilcox <willy@infradead.org>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> In general, headers should not depend on others being included first,
> so this fixes it with a forward declaration for that struct name, but
> we probably want to merge the patch through the scsi tree to help
> bisection.
>
> Fixes: 10e9cbb6b531 ("scsi: target: Convert target drivers to use sbitmap")

Applied to 4.19/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
