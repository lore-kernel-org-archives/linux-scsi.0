From: Jens Axboe <axboe@kernel.dk>
Subject: Re: device support in hpasa, was: Re: OOPS from cciss_ioctl in
 4.12+git
Date: Fri, 7 Jul 2017 09:03:07 -0600
Message-ID: <799cf0d6-658d-4124-1ba0-3962671e3f1e@kernel.dk>
References: <alpine.LRH.2.20.1707051555130.20086@math.ut.ee>
 <20170705225134.GA31786@infradead.org>
 <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
 <20170707150042.GA15445@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170707150042.GA15445@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/07/2017 09:00 AM, Christoph Hellwig wrote:
> On Thu, Jul 06, 2017 at 12:55:04PM +0300, Meelis Roos wrote:
>>> Also we're trying to move people away from the cciss driver, can you
>>> check if the hpsa SCSI driver works for you as well?
>>
>> I have older adapter:
>>
>> Compaq Computer Corporation Smart Array 64xx [0e11:0046] (rev 01)
>>
>> That does not seem to be supported by hpsa AFAICS.
> 
> Looks like.  Although hpsa has support for various SA5 controllers
> it seems like it decided to skip all Compaq branded controllers.
> 
> As far as I can tell we could simply add support for those to
> hpsa.  Ccing hpsa folks to figure out if that's the case.

Pretty sure Hannes had a patch he tested for that, he talked about
that back at LSFMM earlier this year. Hannes?

-- 
Jens Axboe
