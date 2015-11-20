From: Ewan Milne <emilne@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Fri, 20 Nov 2015 10:28:43 -0500
Message-ID: <1448033323.4067.24.camel@localhost.localdomain>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
	 <1447894964.15206.0.camel@ellerman.id.au>
	 <20151119082325.GA11419@infradead.org>  <564DEC41.5010600@suse.de>
	 <1448030316.4067.18.camel@localhost.localdomain> <564F3453.9040603@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564F3453.9040603@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-11-20 at 15:55 +0100, Hannes Reinecke wrote:
> Can't we have a joint effort here?
> I've been spending a _LOT_ of time trying to debug things here, but
> none of the ideas I've come up with have been able to fix anything.

Yes.  I'm not the one primarily looking at it, and we don't have a
reproducer in-house.  We just have the one dump right now.

> 
> I'm almost tempted to increase the count from scsi_alloc_sgtable()
> by one and be done with ...
> 

That might not fix it if it is a problem with the merge code, though.
