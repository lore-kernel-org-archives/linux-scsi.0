From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 4/4] scsi: provide UAPI version of scsi/sg.h and
 scsi/scsi_ioctl.h
Date: Fri, 25 Sep 2015 08:22:56 -0700
Message-ID: <560566D0.4010607@sandisk.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-5-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-5-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/25/2015 02:28 AM, Paolo Bonzini wrote:
> Provide a UAPI version of the header in the kernel, making it easier
> for interested projects to use an up-to-date version of the header.
>
> The new headers are placed under uapi/linux/ so as not to conflict
> with the glibc-provided headers in /usr/include/scsi.
>
> /dev/sgN default values are implementation aspects, and are moved to
> drivers/scsi/sg.c instead (together with e.g. SG_ALLOW_DIO_DEF).
> However, SG_SCATTER_SZ is used by Wine so it is kept in linux/sg.h
> SG_MAX_QUEUE could also be useful.
>
> struct scsi_ioctl_command and struct scsi_idlun used to be under
> "#ifdef __KERNEL__", but they are actually useful for userspace as
> well.  Add them to the new header.
>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
