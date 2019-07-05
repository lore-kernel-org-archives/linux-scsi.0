From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
Date: Fri, 5 Jul 2019 09:52:16 +0200
Message-ID: <ec1a4902-d661-3a63-2dca-ca7692e225ae@suse.de>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-3-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-3-pbonzini@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 5/30/19 1:28 PM, Paolo Bonzini wrote:
> Adding the command and kicking the virtqueue so far was done one after
> another.  Make the kick optional, so that we can take into account SCMD_LAST.
> We also need a commit_rqs callback to kick the device if blk-mq aborts
> the submission before the last request is reached.
> 
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
