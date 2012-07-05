From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/6] tcm_vhost: Initial merge for vhost level target fabric
 driver
Date: Thu, 05 Jul 2012 17:47:11 +0000
Message-ID: <4FF5D31F.90404@acm.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org> <1341375846-27882-5-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1341375846-27882-5-git-send-email-nab@linux-iscsi.org>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/04/12 04:24, Nicholas A. Bellinger wrote:

> +/* Fill in status and signal that we are done processing this command
> + *
> + * This is scheduled in the vhost work queue so we are called with the owner
> + * process mm and can access the vring.
> + */
> +static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
> +{


As far as I can see vhost_scsi_complete_cmd_work() runs on the context
of a work queue kernel thread and hence doesn't have an mm context. Did
I misunderstand something ?

Bart.
