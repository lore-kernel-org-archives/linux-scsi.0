From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/4] scsi: provide UAPI version of scsi/sg.h and
 scsi/scsi_ioctl.h
Date: Thu, 17 Sep 2015 08:32:15 -0700
Message-ID: <55FADCFF.5000104@sandisk.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
 <1442497647-17778-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442497647-17778-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/17/2015 06:47 AM, Paolo Bonzini wrote:
> +
> +#ifndef __KERNEL__
> +/* Keep in sync with SG_DEFAULT_TIMEOUT of scsi/sg.h  */
>   #define SG_DEFAULT_TIMEOUT	(60*HZ)	     /* HZ == 'jiffies in 1 second' */
>   #endif

Is it useful and/or necessary to export this constant ? To me this 
looks like an implementation aspect rather than an aspect of the scsi-sg 
API.

Bart.
