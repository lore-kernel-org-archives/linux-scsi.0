From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V4 06/16] block: Add zoned block device information to
 request queue
Date: Sun, 24 Sep 2017 18:34:32 +0200
Message-ID: <3275ff44-7bd7-a862-8174-62ad42335a45@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924070247.25560-7-damien.lemoal@wdc.com>
 <20170924145923.GD14806@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924145923.GD14806@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 9/24/17 16:59, Christoph Hellwig wrote:
>> +	 * Zoned block device information for mq I/O schedulers.
>> +	 * Set by low level device driver (stacking driver may not set this).
>> +	 */
>> +	unsigned int	nr_zones;
>> +	unsigned long	*seq_zones;
> 
> Might be worth explaining the seq_zones is a bit bitmap to check
> if a given zone number is sequential.
> 
> And maybe give it a name that hints at that, like seq_zone_bitmap?
> 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks. Will send a V5 with your suggested modifications.


-- 
Damien Le Moal
Western Digital Research
