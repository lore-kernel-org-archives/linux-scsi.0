From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: provide UAPI version of scsi/sg.h and
	scsi/scsi_ioctl.h
Date: Wed, 16 Sep 2015 15:39:26 +0200
Message-ID: <20150916133926.GA9658@lst.de>
References: <1442308888-17911-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442308888-17911-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, houcheng@gmail.com, Andy Grover <agrover@redhat.com>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Paolo,

can you just move them to include/linux/ directly?

Also scsi/scsi.h has some additional ioctl defintions that should be
added to the UAPI scsi_ioctl.h.  Otherwise this looks ok to me.
