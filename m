From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH-v2 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
Date: Thu, 22 May 2014 20:30:18 +0930
Message-ID: <87vbsyqdrx.fsf@rustcorp.com.au>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com> <1400725582-5521-2-git-send-email-nab@daterainc.com> <20140522065716.GB29474@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:42979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaEVLJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2014 07:09:14 -0400
In-Reply-To: <20140522065716.GB29474@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Thu, May 22, 2014 at 02:26:17AM +0000, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>> 
>> This patch adds a virtio_scsi_cmd_req_pi header as recommened by
>> Paolo that contains do_pi_niov + di_pi_niov elements used for
>> signaling when protection information buffers are expected to
>> preceed the data buffers.
>
> Cc rusty.
> Rusty could you please Ack merging this through Nicholas' tree
> together with the vhost changes?

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
