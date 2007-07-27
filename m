From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 15:59:39 -0400
Message-ID: <46AA4EAB.4000203@garzik.org>
References: <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org> <46AA150A.5090804@garzik.org> <20070727173613.GN21219@parisc-linux.org> <46AA2DB7.4010707@garzik.org> <20070727180447.GP21219@parisc-linux.org> <46AA4951.3040102@garzik.org> <20070727194652.GR21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761372AbXG0T7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 15:59:41 -0400
In-Reply-To: <20070727194652.GR21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Possibly you've misunderstood the code slightly -- for the case of a
> dual-channel EISA board, the two hosts will have the same interrupt
> number.  So we do need to keep the current code which sets IRQF_SHARED
> on EISA interrupts.  I'm not quite sure why that's not the case for
> the ABP852 dual-channel VLB card -- possibly each channel has its own
> interrupt.  I don't know if VLB can do that or not.

EISA can do shared interrupts and VLB cannot, according to some quick 
Googling.

Are you certain you're not confusing adapters with channels?  I don't 
see where the same I/O port is registered multiple times.  Or does EISA 
present multiple channels via multiple I/O ports (multiple 
advansys_board_found calls)?

	Jeff


