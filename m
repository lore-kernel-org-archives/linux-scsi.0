From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Thu, 9 Aug 2018 10:05:43 +0200
Message-ID: <20180809080543.xvjoya74j66sadvg@linux-x5ow.site>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, ard <ard@kwaak.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 06, 2018 at 11:25:03AM +0200, Johannes Thumshirn wrote:
Martin,

though it looks like these patches aren't fixing all of the errors Ard
has, they fix all I could reproduce up to now and Ard already stated
they're not regressing.

So can we please stage them for 4.19?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
