From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi: virtio_scsi: Use struct_size() helper
Date: Fri, 12 Jul 2019 10:14:23 -0400
Message-ID: <20190712101408-mutt-send-email-mst@kernel.org>
References: <20190619192833.GA825@embeddedor>
 <yq1a7dk9kb5.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1a7dk9kb5.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 11, 2019 at 08:18:54PM -0400, Martin K. Petersen wrote:
> 
> Gustavo,
> 
> > One of the more common cases of allocation size calculations is finding
> > the size of a structure that has a zero-sized array at the end, along
> > with memory for some number of elements for that array. For example:
> 
> Applied to 5.4/scsi-queue, thanks!

Oh I put it in the virtio tree already.
Can't hurt I guess :)

> -- 
> Martin K. Petersen	Oracle Linux Engineering
