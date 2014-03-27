From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 16/39] virtio_scsi: use cmd_size
Date: Thu, 27 Mar 2014 08:28:19 -0700
Message-ID: <1395934099.3718.9.camel@dabdike>
References: <20140317132733.789623766@bombadil.infradead.org>
	 <20140317133133.814453025@bombadil.infradead.org>
	 <20140325153104.GA25748@infradead.org> <5331A27C.8060303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5331A27C.8060303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-25 at 16:36 +0100, Paolo Bonzini wrote:
> Il 25/03/2014 16:31, Christoph Hellwig ha scritto:
> > Paolo,
> >
> > do you have a virtio_scsi tree to picks this up in?  We now have all
> > the infrastructure for it in James' tree.
> 
> I don't, I usually just give my Acked-by and James picks it up.

OK, since we have the acked by, this can go in ... there are some other
dependent patches as well, I think, could you resend those as a separate
series too, please Christoph.

James
