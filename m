From: Christoph Hellwig <hch@infradead.org>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Thu, 7 Aug 2003 10:47:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807104736.A4137@infradead.org>
References: <200308051041.08078.gene.heskett@verizon.net> <20030806104041.4a09f4f0.rddunlap@osdl.org> <20030807083626.B766@infradead.org> <200308070533.10408.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:5639 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S275242AbTHGJrl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 05:47:41 -0400
Content-Disposition: inline
In-Reply-To: <200308070533.10408.gene.heskett@verizon.net>; from gene.heskett@verizon.net on Thu, Aug 07, 2003 at 05:33:10AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Gene Heskett <gene.heskett@verizon.net>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org

On Thu, Aug 07, 2003 at 05:33:10AM -0400, Gene Heskett wrote:
> But I'm getting tired of repeating myself here Christoph, the driver 
> as built in the 2.6.0-test2-mm2, whether built as a module, or in the 
> kernel, IS BROKEN!  It gets into a bus reset loop during the init, 
> doing 2 of them, AND LOCKS THE MACHINE UP TIGHT REQUIRING A HARDWARE 
> RESET TO RECOVER, which of course is by rebooting back to a 2.4 
> kernel.

So how do you think replacing check_region by it's opencoded version
is going to help you?

