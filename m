From: Asias He <asias@redhat.com>
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
Date: Wed, 18 Jul 2012 10:09:23 +0800
Message-ID: <50061AD3.6030704@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <20120717150928.GB11587@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20120717150928.GB11587@redhat.com>
Sender: owner-linux-aio@kvack.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/17/2012 11:09 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 13, 2012 at 04:55:06PM +0800, Asias He wrote:
>>
>> Hi folks,
>>
>> [I am resending to fix the broken thread in the previous one.]
>>
>> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
>> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
>> gives about 5% to 15% performance improvement.
>
> Same thing as tcm_host comment:
>
> 	It seems not 100% clear whether this driver will have major
> 	userspace using it. And if not, it would be very hard to support a
> 	driver when recent userspace does not use it in the end.
>
> 	I think a good idea for 3.6 would be to make it depend on
> 	CONFIG_STAGING.  Then we don't commit to an ABI.  For this, you can add
> 	a separate Kconfig and source it from drivers/staging/Kconfig.  Maybe it
> 	needs to be in a separate directory drivers/vhost/staging/Kconfig.

OK.

> I Cc'd the list of tcm_host in the hope that you can cooperate on this.

Sure.

-- 
Asias


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
