From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device
	driver.
Date: Fri, 24 Mar 2006 15:55:27 +0000
Message-ID: <1143215728.18986.15.camel@localhost.localdomain>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>
	<4421D943.1090804@garzik.org>
	<1143202673.18986.5.camel@localhost.localdomain>
	<4423E853.1040707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <4423E853.1040707@garzik.org>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Jeff Garzik <jeff@garzik.org>
Cc: Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, xen-devel@lists.xensource.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Ian Pratt <ian.pratt@xensource.com>, linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org
List-Id: linux-scsi@vger.kernel.org

On Gwe, 2006-03-24 at 07:38 -0500, Jeff Garzik wrote:
> > A pure SCSI abstraction doesn't allow for shared head scheduling which
> > you will need to scale Xen sanely on typical PC boxes.
> 
> Not true at all.  If you can do it with a block device, you can do it 
> with a SCSI block device.

I don't believe this is true. The complexity of expressing sequences of
command ordering between virtual machines acting in a co-operative but
secure manner isn't as far as I can see expressable sanely in SCSI TCQ
> 
> In fact, SCSI should make a few things easier, because the notion of 
> host+bus topology is already present, and notion of messaging is already 
> present, so you don't have to recreate that in a Xen block device 
> infrastructure.

Those are the easy bits. 

> > are also always full of bits people got wrong, often critical bits like
> > tagged queues and error sequences - things that break your journalled
> > file system.
> 
> This I'll grant you.

And every one you get wrong is a corruptor....

Alan
