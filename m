From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device
	driver.
Date: Sat, 25 Mar 2006 21:03:11 +1100
Message-ID: <1143280992.8228.12.camel@localhost.localdomain>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>
	<4421D943.1090804@garzik.org>
	<1143202673.18986.5.camel@localhost.localdomain>
	<4423E853.1040707@garzik.org>
	<1143215728.18986.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <1143215728.18986.15.camel@localhost.localdomain>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: xen-devel@lists.xensource.com, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, virtualization@lists.osdl.org, linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2006-03-24 at 15:55 +0000, Alan Cox wrote:
> On Gwe, 2006-03-24 at 07:38 -0500, Jeff Garzik wrote:
> > > A pure SCSI abstraction doesn't allow for shared head scheduling which
> > > you will need to scale Xen sanely on typical PC boxes.
> > 
> > Not true at all.  If you can do it with a block device, you can do it 
> > with a SCSI block device.
> 
> I don't believe this is true. The complexity of expressing sequences of
> command ordering between virtual machines acting in a co-operative but
> secure manner isn't as far as I can see expressable sanely in SCSI TCQ

I thought usb_scsi taught us that SCSI was overkill for a block
abstraction?  I have a much simpler Xen block-device implementation
which seems to perform OK, and is a lot less LOC than the in-tree one,
so I don't think the "SCSI would be better than what's there" (while
possibly true) is valid.

Cheers!
Rusty.
-- 
 ccontrol: http://ozlabs.org/~rusty/ccontrol
