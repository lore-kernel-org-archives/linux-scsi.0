From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [RFC PATCH 00/32] separate operations from flags in
 the bio/request structs
Date: Wed, 11 Nov 2015 01:53:24 -0600
Message-ID: <5642F3F4.2060007@cs.wisc.edu>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
 <563A36FC.6010001@sandisk.com> <563A3813.5010604@cs.wisc.edu>
 <20151107102309.GE12117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151107102309.GE12117@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On 11/07/2015 04:23 AM, Christoph Hellwig wrote:
> On Wed, Nov 04, 2015 at 10:53:39AM -0600, Mike Christie wrote:
>>> If you have to touch submit_bio() and submit_bio_wait(), how about
>>> requiring the callers of these functions to set the cmd and flags
>>> arguments in the bio structure and to leave out the cmd and flags
>>> arguments from the submit_bio() and submit_bio_wait() functions ? A
>>> (compile tested only) patch that implements this idea is available at
>>> https://lkml.org/lkml/2014/6/2/173.
>>>
>>
>> Yeah, I can do that.
> 
> I think this would be useful to do at the beginning of the series.

I just wanted to double check that we wanted to do this.

We no longer have the bvec merge functions so the original reason given
in the thread/patch Bart referenced is no longer valid.

Offlist it was suggested that dropping the argument from submit_bio
might still improve performance, but I modified xfs and dm and did some
testing and did not see anything.

So the change is not needed, and it would only be done because people
feel it would improve the interface.

