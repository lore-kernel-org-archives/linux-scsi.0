From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 0/2] virtio-scsi: Implement FC_HOST feature
Date: Tue, 17 Jan 2017 11:37:14 +0800
Message-ID: <20170117033714.GA21563@lemon.Home>
References: <20170116160430.11815-1-famz@redhat.com>
 <20170116173429.GA3852@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdAQDhT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Jan 2017 22:37:19 -0500
Content-Disposition: inline
In-Reply-To: <20170116173429.GA3852@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On Mon, 01/16 09:34, Christoph Hellwig wrote:
> On Tue, Jan 17, 2017 at 12:04:28AM +0800, Fam Zheng wrote:
> > This series implements the proposed fc_host feature of virtio-scsi.
> 
> Yikes.  Why?

Hi Christoph, this is mostly to "passthrough" a host NPIV vport (leaving libvirt
doing the heavy lifting to watch and attach all visible LUNs to guest).

Fam

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
