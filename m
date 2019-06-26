From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Date: Wed, 26 Jun 2019 15:51:32 +0200
Message-ID: <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-1-pbonzini@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 30/05/19 13:28, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
> 
> This applies to any HBA, either singlequeue or multiqueue; the second
> patch implements it for virtio-scsi.
> 
> Paolo
> 
> Paolo Bonzini (2):
>   scsi_host: add support for request batching
>   virtio_scsi: implement request batching
> 
>  drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  include/scsi/scsi_cmnd.h   |  1 +
>  include/scsi/scsi_host.h   | 16 +++++++++--
>  4 files changed, 89 insertions(+), 20 deletions(-)
> 


Ping?  Are there any more objections?

Paolo
