From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/2] virtio_scsi: Set can_queue based on size of virtqueue.
Date: Thu, 10 Aug 2017 20:24:40 -0400
Message-ID: <yq14ltf2bp3.fsf@oracle.com>
References: <20170810165652.21515-1-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170810165652.21515-1-rjones@redhat.com> (Richard W. M. Jones's
        message of "Thu, 10 Aug 2017 17:56:50 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mst@redhat.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org


Richard,

> v1 was here:
>
>   https://lkml.org/lkml/2017/8/10/689
>
> v1 -> v2:
>
>   Remove .can_queue field from the templates.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
