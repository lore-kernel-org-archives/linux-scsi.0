From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 4/5] target/qla2xxx: Define NPIV ops in terms of normal
 ops
Date: Wed, 21 Aug 2013 09:02:32 -0700
Message-ID: <5214E498.6020504@redhat.com>
References: <1377046807-15860-1-git-send-email-agrover@redhat.com> <1377046807-15860-5-git-send-email-agrover@redhat.com> <20130821063008.GD25506@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20130821063008.GD25506@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/20/2013 11:30 PM, Christoph Hellwig wrote:
> On Tue, Aug 20, 2013 at 06:00:06PM -0700, Andy Grover wrote:
>> Instead of defining a second target_core_fabric_ops struct, use the
>> same one as normal (tcm_qla2xxx_ops) and then fixup the changed methods.
>>
>> This should make it a little easier to pick out the npiv differences, and
>> also save a little space.
>>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>
> Can't say I'm a huge fan of either the old or new way, I'd rather have
> the methods contain both the NPIV and non-NPIV code inline.  If that's
> what you're preparing for I'm supportive of this, otherwise I don't
> really care too much about it.  Looks correct at least..

It reduces the binary size and makes it easier to spot the differences 
between the two cases, which was the goal. So I think it's a small 
improvement but if others disagree then I'm fine with the code as-is.

Regards -- Andy
