From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Thu, 19 Jul 2012 08:00:44 +0200
Message-ID: <5007A28C.602@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org> <20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com> <1342561819.18004.470.camel@haakon2.linux-iscsi.org> <5006BD3D.7090104@us.ibm.com> <20120718155338.GA21817@infradead.org> <5006DDAA.6080304@us.ibm.com> <1342630038.3022.111.camel@dabdike.int.hansenpartnership.com> <50070A8D.7020203@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <50070A8D.7020203@us.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Il 18/07/2012 21:12, Anthony Liguori ha scritto:
> Is that true for all OSes?  Linux may handle things gracefully if UNMAP
> starts throwing errors but that doesn't mean that Windows will.

There is so much USB crap (not just removable, think of ATA-to-USB
enclosures) that they have to deal with pretty much everything.

> Windows does this with a points system and I do believe that INQUIRY
> responses from any local disks are included in this tally.

INQUIRY responses (at least vendor/product/type) should not change.

Paolo
