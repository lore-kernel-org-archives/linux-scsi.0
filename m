From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH net v7 3/7] cxgb4/cxgb4i: set the max. pdu length in
 firmware
Date: Wed, 10 Dec 2014 23:41:29 +0300
Message-ID: <1418244089.8310.15.camel@HansenPartnership.com>
References: <201412102024.sBAKO9eA011525@localhost6.localdomain6>
	 <20141210.153159.617405179156473446.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20141210.153159.617405179156473446.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: kxie@chelsio.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-12-10 at 15:31 -0500, David Miller wrote:
> From: Karen Xie <kxie@chelsio.com>
> Date: Wed, 10 Dec 2014 12:24:09 -0800
> 
> > [PATCH net v7 3/7] cxgb4/cxgb4i: set the max. pdu length in firmware.
> 
> Please listen to the feedback you have been given.
> 
> Again, you should not duplicate the Subject line in your message
> body, that makes more work for the people integrating your patches
> as we have to remove all of these things by hand.

While we're on the subject of making life easier for maintainers, could
I put in a plea for threading your patch set?  It really does make it
easier to find and apply all the patches, especially on a high traffic
list where they otherwise get interspersed with other messages.  If you
don't use git-send-email, which threads automatically, you can thread
manually by just making all the other patches a reply to your [PATCH
0/N],

James
