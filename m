From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 00/10] block, scsi, md: Improve suspend and resume
Date: Tue, 17 Oct 2017 19:47:26 -0600
Message-ID: <94c627b3-fd59-a669-5ea0-0c4afdc7b2d3@kernel.dk>
References: <20171017232630.4264-1-bart.vanassche@wdc.com>
 <9c33db06-39e7-fd61-f146-4ae6df4302b5@kernel.dk>
 <1508283619.3457.24.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1508283619.3457.24.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 05:40 PM, Bart Van Assche wrote:
> On Tue, 2017-10-17 at 17:28 -0600, Jens Axboe wrote:
>> On 10/17/2017 05:26 PM, Bart Van Assche wrote:
>>> It is known that during the resume following a hibernate, especially when
>>> using an md RAID1 array created on top of SCSI devices, sometimes the system
>>> hangs instead of coming up properly. This patch series fixes that
>>> problem. These patches have been tested on top of the block layer for-next
>>> branch. Please consider these changes for kernel v4.15.
>>
>> The folks that had trouble with this issue, have they tested the
>> patchset? I'd like to get a solution queued up for this sooner rather
>> than later, but I'd greatly prefer if we had some folks that have
>> tested and verified it.
> 
> Hello Jens,
> 
> Previous versions of this series have been tested by the two reporters of
> this issue (Oleksandr Natalenko and Martin Steigerwald). I think this version
> is close enough to what has been tested by Oleksandr and Martin for their
> test results still to be valid. See also:
> * https://www.mail-archive.com/linux-block@vger.kernel.org/msg13930.html
> * https://www.mail-archive.com/linux-block@vger.kernel.org/msg14389.html

OK good. Can we add their tested-by then?

-- 
Jens Axboe
