From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Tue, 15 May 2018 10:20:37 -0600
Message-ID: <6ab7d206-ba46-6b1e-5210-4894ec4dc553@kernel.dk>
References: <20180515160043.27044-1-willy@infradead.org>
 <20180515160043.27044-2-willy@infradead.org>
 <3a56027b-47bc-dcb8-a465-3670031572f1@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a56027b-47bc-dcb8-a465-3670031572f1@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 5/15/18 10:11 AM, Jens Axboe wrote:
> On 5/15/18 10:00 AM, Matthew Wilcox wrote:
>> From: Matthew Wilcox <mawilcox@microsoft.com>
>>
>> The sbitmap and the percpu_ida perform essentially the same task,
>> allocating tags for commands.  Since the sbitmap is more used than
>> the percpu_ida, convert the percpu_ida users to the sbitmap API.
> 
> It should also be the same performance as percpu_ida in light use, and
> performs much better at > 50% utilization of the tag space. I think
> that's better justification than "more used than".

Had to search long and hard for the perf numbers I did for percpu_ida
on higher utilization, but here it is:

https://lkml.org/lkml/2014/4/22/553

-- 
Jens Axboe
