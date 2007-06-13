From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Wed, 13 Jun 2007 14:51:06 +0000
Message-ID: <20070613145106.GA8053@ucw.cz>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com> <466E1EC6.90509@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <466E1EC6.90509@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <htejun@gmail.com>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi!

> >Yeah, it was some Lenovo notebook.  Pavel is more 
> >familiar with the
> >hardware.  Pavel, what was the notebook which didn't 
> >save much power
> >with standard SATA power save but needed port to be 
> >completely turned off?
> 
> Pavel, if you have time, could you measure this with 
> Kristen's patch?

Kristen has same machine as me, and I have seen similar '1W' saving
with previous version of the patch. I'd trust her results.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
