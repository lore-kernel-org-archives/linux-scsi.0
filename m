From: ard <ard@kwaak.net>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Mon, 6 Aug 2018 15:22:34 +0200
Message-ID: <20180806132234.GA23827@kwaak.net>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Johannes,

On Mon, Aug 06, 2018 at 11:25:03AM +0200, Johannes Thumshirn wrote:
> Ard,
> 
> Did you have time to test these patches?

Ahh, yeah, sorry.
I did test them.
I can't say I see a regression.
I also can't say I see progress, although it feels like there is
a tad less leaking.
For that I need to do some statistics.

But for now I ack that it does not regress further.

-- 
.signature not found
