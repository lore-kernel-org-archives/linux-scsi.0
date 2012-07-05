From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/6] virtio-scsi: Set shost->max_id=1 for tcm_vhost WWPNs
Date: Thu, 05 Jul 2012 08:42:06 +0200
Message-ID: <4FF5373E.8080703@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<1341375846-27882-7-git-send-email-nab@linux-iscsi.org>
	<4FF45850.20501@redhat.com>
	<1341453940.23954.229.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341453940.23954.229.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Il 05/07/2012 04:05, Nicholas A. Bellinger ha scritto:
>> > But that's what the config field is for... why can't tcm_vhost (or QEMU)
>> > set max_id to 0?
>> > 
> So this patch was carried forward from Stefan's original code that I
> thought was required due to other limitations..
> 
> If that's not the case anymore I'm happy to drop it for now and look
> into a proper fix outside of virtio-scsi.
> 

I think max_id did not exist in the virtio-scsi configuration at the
time Stefan was working on it.

Paolo
