From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Wed, 16 Jun 2004 18:06:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616220607.GA6451@devserv.devel.redhat.com>
References: <20040616210455.GA13385@devserv.devel.redhat.com> <20040616213343.GA20488@infradead.org> <20040616214048.GA27169@devserv.devel.redhat.com> <20040616214257.GA20787@infradead.org> <20040616214825.GA29750@devserv.devel.redhat.com> <20040616215834.GA21072@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:198 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266335AbUFPWG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 18:06:29 -0400
Content-Disposition: inline
In-Reply-To: <20040616215834.GA21072@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2004 at 10:58:34PM +0100, Christoph Hellwig wrote:
> Yikes.  This looked like they usual use 32bit dma descriptors if not
> enough memory hacks to me.  If aacraid is that royally fucked we should
> probably add CONFIG_X86 to it.

Its working on x86-32, x86-64 and I believe (Mark can confirm this) IA-64.
I'm fairly sure there are some platforms that aren't going to fit the
hardware's view of the world which seems to be

0[DMAable area..................]defined limit   [4Gb+.. PAE mode on some]

The later cards also have a 2Gb limit for the ring buffers, but not for the
I/O you want to target


