From: Keith Busch <keith.busch@intel.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 5 Feb 2019 08:16:36 -0700
Message-ID: <20190205151632.GA28064@localhost.localdomain>
References: <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
 <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
 <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
 <d93ff049-e96d-36ce-7e58-ec97cbb27ed0@suse.de>
 <42d149c5-0380-c357-8811-81015159ac04@huawei.com>
 <20190205145244.GB28023@localhost.localdomain>
 <0de6dae8-1234-3e3f-d8f3-2d8de47b7f9e@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0de6dae8-1234-3e3f-d8f3-2d8de47b7f9e@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 05, 2019 at 04:10:47PM +0100, Hannes Reinecke wrote:
> On 2/5/19 3:52 PM, Keith Busch wrote:
> > Whichever layer dispatched the IO to a CPU specific context should
> > be the one to wait for its completion. That should be blk-mq for most
> > block drivers.
> > 
> Indeed.
> But we don't provide any mechanisms for that ATM, right?
> 
> Maybe this would be a topic fit for LSF/MM?

Right, there's nothing handling this now, and sounds like it'd be a good
discussion to bring to the storage track.
