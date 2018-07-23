From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [stable-4.14 00/23] block/scsi multiqueue performance enhancement
 and
Date: Mon, 23 Jul 2018 09:05:02 -0600
Message-ID: <f67eedb1-e78e-36a9-b3f5-f2192e9d079a@kernel.dk>
References: <1532352285-13589-1-git-send-email-jinpuwang@gmail.com>
 <20180723133356.GA1333@kroah.com>
 <CA+res+TE5-mgnQys67zQ8cqRyv+dgNPpTFLOEq81t2izpq1dsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CA+res+TE5-mgnQys67zQ8cqRyv+dgNPpTFLOEq81t2izpq1dsw@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Wang Jinpu <xjtuwjp@gmail.com>, stable@vger.kernel.org, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

On 7/23/18 9:00 AM, Jack Wang wrote:
> Hi Greg,
> 
> Thanks for quick reply. Please see reply inline.
> 
> 
> 
> Greg KH <gregkh@linuxfoundation.org> 于2018年7月23日周一 下午3:34写道：
>>
>> On Mon, Jul 23, 2018 at 03:24:22PM +0200, Jack Wang wrote:
>>> Hi Greg,
>>>
>>> Please consider this patchset, which include block/scsi multiqueue performance
>>> enhancement and bugfix.
>>
>> What exactly is the performance enhancement?  How can you measure it?
>> How did you measure it?
> I'm testing on SRP/IBNBD using fio, I've seen +10% with mix IO load,
> and 50% improvement on small IO (bs=512.) with the patchset.

Big nak on backporting this huge series, it's a lot of core changes.
It's way beyond the scope of a stable fix backport.

-- 
Jens Axboe
