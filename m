From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Fri, 27 Jun 2003 19:04:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627190434.A10771@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:47117 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264606AbTF0RuX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 13:50:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Jun 27, 2003 at 01:56:59PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jun 27, 2003 at 01:56:59PM -0400, Alan Stern wrote:
> I don't see how you can make that work without modifying parts of the 
> driver model core.  After all, calls to a class_device attribute's show() 
> and store() methods don't go through the device driver or the bus driver; 
> they are demultiplexed within drivers/base/class.c.

Right, the intention is to change the device model cope.  See the dicussion
about netdev refcounting on linux-netdev a while ago.  

