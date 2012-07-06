From: Christoph Lameter <cl@linux.com>
Subject: Re: [Ksummit-2012-discuss] SCSI Performance regression [was Re:
 [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6]
Date: Fri, 6 Jul 2012 15:30:57 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207061528520.2656@router.home>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org> <20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com> <20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com> <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
 <4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com> <4FF59F6B.2000101@us.ibm.com> <1341543672.23954.285.camel@haakon2.linux-iscsi.org> <1341553397.3023.16.camel@dabdike.hilton.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1341553397.3023.16.camel@dabdike.hilton.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, ksummit-2012-discuss <ksummit-2012-discuss@lists.linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Jul 2012, James Bottomley wrote:

> What people might pay attention to is evidence that there's a problem in
> 3.5-rc6 (without any OFED crap).  If you're not going to bother
> investigating, it has to be in an environment they can reproduce (so
> ordinary hardware, not infiniband) otherwise it gets ignored as an
> esoteric hardware issue.

The OFED stuff in the meantime is part of 3.5-rc6. Infiniband has been
supported for a long time and its a very important technology given the
problematic nature of ethernet at high network speeds.

OFED crap exists for those running RHEL5/6. The new enterprise distros are
based on the 3.2 kernel which has pretty good Infiniband support
out of the box.
