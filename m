From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 11/12] scsi: sd: Introduce scsi_disk_from_queue()
Date: Tue, 12 Sep 2017 17:05:43 +0900
Message-ID: <e77762b6-eb91-7759-3d1e-f91657bdcc07@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-12-damien.lemoal@wdc.com>
 <20170910051655.GC11628@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170910051655.GC11628@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Ming,

On 9/10/17 14:16, Ming Lei wrote:
> On Fri, Sep 08, 2017 at 01:16:39AM +0900, Damien Le Moal wrote:
>> Using scsi_device_from_queue(), return the scsi_disk structure
>> associated with a request queue if the device is a disk.
>> Export this function to make it available to modules.
>>
> 
> This approach may be a little over-kill, actually gendisk is the
> parent of request queue in kobject tree(see blk_register_queue()),
> that might be an easy way to retrieve disk attached to the queue.

Yes. It is a little extreme.
I am currently preparing a V3 that will have a softer touch.

Best regards.

-- 
Damien Le Moal,
Western Digital
