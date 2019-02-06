From: John Garry <john.garry@huawei.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Wed, 6 Feb 2019 09:21:40 +0000
Message-ID: <3413b0b1-cb3f-3b09-106d-89cf8be30178@huawei.com>
References: <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
 <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
 <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
 <d93ff049-e96d-36ce-7e58-ec97cbb27ed0@suse.de>
 <42d149c5-0380-c357-8811-81015159ac04@huawei.com>
 <20190205145244.GB28023@localhost.localdomain>
 <d4a04c13-b7db-84df-b1d3-90022905c084@huawei.com>
 <20190205182325.GA3302@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205182325.GA3302@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, Hannes Reinecke <hare@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/02/2019 18:23, Christoph Hellwig wrote:
> On Tue, Feb 05, 2019 at 03:09:28PM +0000, John Garry wrote:
>> For SCSI devices, unfortunately not all IO sent to the HW originates from
>> blk-mq or any other single entity.
>
> Where else would SCSI I/O originate from?

Please note that I was referring to other management IO, like SAS SMP, 
TMFs, and other proprietary commands which the driver may generate for 
the HBA - https://marc.info/?l=linux-scsi&m=154831889001973&w=2 
discusses some of them also.

Thanks,
John

>
> .
>
