From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Stop megaraid trashing other i960 based devices
Date: Sat, 22 May 2004 13:11:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522171104.GA7481@devserv.devel.redhat.com>
References: <20040522154659.GA17320@devserv.devel.redhat.com> <20040522160205.GA8643@infradead.org> <20040522160328.GA22256@devserv.devel.redhat.com> <20040522160718.GA8736@infradead.org> <20040522170706.GA27386@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:5601 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261706AbUEVRMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 13:12:16 -0400
Content-Disposition: inline
In-Reply-To: <20040522170706.GA27386@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: hch@infradead.org, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sat, May 22, 2004 at 12:07:06PM -0500, Matt Domsch wrote:
> of that vintage are hard-coded so AMI couldn't have changed them if
> they wanted to.  So their magic words were the equivalent of what we
> now do with subsystem IDs.  It's only the older cards that have a
> problem, AFAIK.

Certain megaraid 3 era cards - so yes quite old stuff only. Its not the
only driver with these kind of problems although the other i960 stuff I have
does all have a unique id or class.

