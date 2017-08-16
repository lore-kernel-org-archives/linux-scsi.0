From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] Revert "scsi: default to scsi-mq"
Date: Wed, 16 Aug 2017 14:13:43 +0300
Message-ID: <c9cb1e15-ccd7-94e3-f064-a89c71237ff8@intel.com>
References: <20170813174422.16197-1-hch@lst.de>
 <1502724064.2333.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1502724064.2333.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 14/08/17 18:21, Bart Van Assche wrote:
> On Sun, 2017-08-13 at 19:44 +0200, Christoph Hellwig wrote:
>> Defaulting to scsi-mq in 4.13-rc has shown various regressions
>> on setups that we didn't previously consider.  Fixes for them are
>> in progress, but too invasive to make it in this cycle.  So for
>> now revert the commit that defaults to blk-mq for SCSI.  For 4.14
>> we'll plan to try again with these fixes.
> 
> Should a patch for v4.14 perhaps be queued now?
Please consider adding support for runtime pm first.  For people using
scsi/ufs/ufshcd it might be an essential feature.
