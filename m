From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention
 conditions
Date: Tue, 17 Jul 2012 22:59:50 +0100
Message-ID: <1342562390.3039.100.camel@dabdike.int.hansenpartnership.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
	 <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
	 <50044D56.6000400@redhat.com>
	 <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
	 <50052390.7030908@redhat.com>
	 <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
	 <5005285E.8060706@redhat.com>
	 <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
	 <20120717163612.GA15995@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120717163612.GA15995@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-17 at 12:36 -0400, Christoph Hellwig wrote:
> On Tue, Jul 17, 2012 at 10:11:57AM +0100, James Bottomley wrote:
> > There's no such thing in the market today as a removable disk that's
> > resizeable.  Removable disks are for things like backup cartridges and
> > ageing jazz drives.  Worse: most removeable devices today are USB card
> > readers whose standards compliance varies from iffy to non existent.
> > Resizeable disks are currently the province of storage arrays.
> 
> The virtual disks exported by aacraid are both marked removable and
> can be resized.

So what are properties of these things? ... or is this just an instance
of a RAID manufacturer hacking around a problem by adding a removable
flag?

James
