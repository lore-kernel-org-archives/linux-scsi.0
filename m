From: Mark Salter <msalter@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Fri, 20 Nov 2015 08:37:02 -0500
Message-ID: <1448026622.3974.28.camel@redhat.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
	 <1447894964.15206.0.camel@ellerman.id.au>
	 <20151119082325.GA11419@infradead.org>
	 <1448021448.14769.7.camel@ellerman.id.au>
	 <564F188F.4080502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564F188F.4080502@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>
Cc: "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-11-20 at 13:56 +0100, Laurent Dufour wrote:
> On 20/11/2015 13:10, Michael Ellerman wrote:
> > On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
> > 
> > > It's pretty much guaranteed a block layer bug, most likely in the
> > > merge bios to request infrastucture where we don't obey the merging
> > > limits properly.
> > > 
> > > Does either of you have a known good and first known bad kernel?
> > 
> > Not me, I've only hit it one or two times. All I can say is I have hit it in
> > 4.4-rc1.
> > 
> > Laurent, can you narrow it down at all?
> 
> I'm trying bisect it but it's very time consuming, and I think I missed
> some bad kernel because I didn't let enough time to the system to panic.
> 
> But I'm still on...
> 
I usually hit it at boot time. Maybe one out of five times. I'll take a stab
at bisecting today...
