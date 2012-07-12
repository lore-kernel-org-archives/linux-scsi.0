From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-v2] virtio-scsi: Add vdrv->scan for post
	VIRTIO_CONFIG_S_DRIVER_OK LUN scanning
Date: Thu, 12 Jul 2012 09:32:22 +0200
Message-ID: <4FFE7D86.2010204@redhat.com>
References: <1342041736-30043-1-git-send-email-nab@linux-iscsi.org>
	<1342077828.3021.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1342077828.3021.1.camel@dabdike.int.hansenpartnership.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 12/07/2012 09:23, James Bottomley ha scritto:
>> > Cc: Paolo Bonzini <pbonzini@redhat.com>
>> > Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
>> > Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
>> > Cc: Christoph Hellwig <hch@lst.de>
>> > Cc: Hannes Reinecke <hare@suse.de>
>> > Cc: James Bottomley <JBottomley@Parallels.com>
>> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Was the change so great that it needs re acking?

Not really, but anyway

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

> I assume it also now no longer applies to stable because it will reject?

Yes, stable will have to use v1.

Paolo
