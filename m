From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 17:53:24 +0000
Message-ID: <4FF5D494.2090707@acm.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>  <20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>  <20120704150557.GA26951@redhat.com>  <4FF4BFBD.2080000@us.ibm.com> <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Anthony Liguori <aliguori@us.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/05/12 01:52, Nicholas A. Bellinger wrote:

> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> ------------------------------------------------------------------------------------
> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K


These numbers are interesting. To me these numbers mean that there is a
huge performance bottleneck in the virtio-scsi-raw storage path. Why is
the virtio-scsi-raw bandwidth only one third of the bare-metal raw block
bandwidth ?

Bart.
