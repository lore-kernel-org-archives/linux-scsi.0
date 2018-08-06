From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Mon, 6 Aug 2018 15:27:25 +0200
Message-ID: <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
 <20180806132234.GA23827@kwaak.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806132234.GA23827@kwaak.net>
Sender: linux-kernel-owner@vger.kernel.org
To: ard <ard@kwaak.net>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 06, 2018 at 03:22:34PM +0200, ard wrote:
> Ahh, yeah, sorry.
> I did test them.
> I can't say I see a regression.
> I also can't say I see progress, although it feels like there is
> a tad less leaking.
> For that I need to do some statistics.
> 
> But for now I ack that it does not regress further.

>From what I've seen in your kmemleak reports, it wasn't only
libfc/fcoe that was leaking memory.

So kmemleak reports are welcome (especially if they confirm libfc/fcoe
is clean now ;-)).

@Martin can you stage these patches for 4.19?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
