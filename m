From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Thu, 10 Jan 2013 09:44:56 +0100
Message-ID: <50EE7F88.1010100@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<87r4m45g88.fsf@rustcorp.com.au> <50E54DC0.4040609@redhat.com>
	<87pq1h508k.fsf@rustcorp.com.au> <50EADB62.1010704@redhat.com>
	<87wqvo3542.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <87wqvo3542.fsf@rustcorp.com.au>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

Il 08/01/2013 01:12, Rusty Russell ha scritto:
>>>> >>> Unfortunately, that cannot work because not all architectures support
>>>> >>> chained scatterlists.
>>> >> 
>>> >> WHAT?  I can't figure out what an arch needs to do to support this?
>> >
>> > It needs to use the iterator functions in its DMA driver.
> But we don't care for virtio.

True.

>>> >> All archs we care about support them, though, so I think we can ignore
>>> >> this issue for now.
>> >
>> > Kind of... In principle all QEMU-supported arches can use virtio, and
>> > the speedup can be quite useful.  And there is no Kconfig symbol for SG
>> > chains that I can use to disable virtio-scsi on unsupported arches. :/
> Well, we #error if it's not supported.  Then the lazy architectures can
> fix it.

Yeah, that would be one approach.

But frankly, your patch is really disgusting. :)  Not your fault, of
course, but I still prefer a limited amount of duplication.

Perhaps we can get the best of both worlds, I'll take a look when I have
some time.

Paolo
