From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Wed, 7 Jan 2009 10:41:06 +0800
Message-ID: <20090107024105.GA20931@sli10-desk.sh.intel.com>
References: <20090104092430.7ffd2c41@infradead.org> <1231135294.8179.45.camel@nigel-laptop> <20090105025300.3afbec23@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090105025300.3afbec23@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "ncunningham-lkml@crca.org.au" <ncunningham-lkml@crca.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2009 at 06:53:00PM +0800, Arjan van de Ven wrote:
> On Mon, 05 Jan 2009 17:01:34 +1100
> Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:
> 
> > Hi Arjan.
> > 
> > Great work, and valuable too. I'm just wondering if the header file
> > name "async.h" is a little too generic? Something like async_init.h
> > perhaps?
> > 
> 
> while the users I have in mind are during init, the concept and
> infrastructure of asynchronous function calls is by no means limited to
> that use case... I hope there are many other uses for this :)
This can be used for shutdown too. Some drivers like sata and serio
shutdown time is long.

Thanks,
Shaohua
