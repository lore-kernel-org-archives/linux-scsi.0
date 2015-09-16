From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: provide UAPI version of scsi/sg.h and
 scsi/scsi_ioctl.h
Date: Wed, 16 Sep 2015 16:15:46 +0200
Message-ID: <55F97992.6050905@redhat.com>
References: <1442308888-17911-1-git-send-email-pbonzini@redhat.com>
 <20150916133926.GA9658@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150916133926.GA9658@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, houcheng@gmail.com, Andy Grover <agrover@redhat.com>, James Bottomley <jbottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 16/09/2015 15:39, Christoph Hellwig wrote:
> Hi Paolo,
> 
> can you just move them to include/linux/ directly?

I'm trying to cater to the objections that were made to Andy's patch.
If you mean the non-UAPI headers, James wanted them to stay in scsi/; if
you mean the UAPI headers, Douglas complained about the flat structure
of include/linux/.

> Also scsi/scsi.h has some additional ioctl defintions that should be
> added to the UAPI scsi_ioctl.h.  Otherwise this looks ok to me.

I can do this, but I think they are obsoleted by SG_GET_SCSI_ID, except
for SCSI_IOCTL_GET_PCI which is horrible anyway. :)  The comment about
conflicts with CDROM ioctls is also interesting.  I can see why one
would want to keep them out of the new canonical place for SCSI ioctls.

Paolo
