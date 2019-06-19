From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [resend] wd719x: Fix resets and aborts
Date: Tue, 18 Jun 2019 21:45:42 -0400
Message-ID: <yq1v9x2wdo9.fsf@oracle.com>
References: <20190617175012.25323-1-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617175012.25323-1-linux@zary.sk> (Ondrej Zary's message of
        "Mon, 17 Jun 2019 19:50:12 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Hariprasad Kelam <hariprasad.kelam@gmail.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, David Rientjes <rientjes@google.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ondrej,

> Host reset oopses because it calls wd719x_chip_init, which calls
> request_firmware, under a spinlock. Stop the RISC first, then flush
> active SCBs under a spinlock. Finally call wd719x_chip_init unlocked.

Applied to 5.3/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
