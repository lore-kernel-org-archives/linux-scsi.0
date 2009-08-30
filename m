From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sun, 30 Aug 2009 13:14:38 -0400
Message-ID: <20090830171438.GA12178@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A9A5E89.7070204@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A9A5E89.7070204@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 30, 2009 at 03:12:09PM +0400, Sergei Shtylyov wrote:
>> +	printk(KERN_INFO "umap, lba = 0x%lld, len = %d\n",
>>   
>
>   So, is it hex or decimal? :-)
>
>> +	       bio->bi_sector, bio_sectors(bio));
>>   
>
>   Since bio->bi_sector can either be 4 or 8 bytes, you need a cast to  
> unsigned long long here.

Indeed.  But as this is justa debug printk that slipped through I will
just remove it completely in the next iteration.

