From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/21] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 10:55:39 -0400
Message-ID: <46AA076B.5070002@garzik.org>
References: <11854705772-git-send-email-matthew@wil.cx> <46A8F850.3070102@garzik.org> <20070726203748.GR19275@parisc-linux.org> <46A9F842.6040209@garzik.org> <20070727141652.GE21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58479 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbXG0Ozk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:55:40 -0400
In-Reply-To: <20070727141652.GE21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Jul 27, 2007 at 09:50:58AM -0400, Jeff Garzik wrote:
>>> Would it make sense to put in a comment that says "No idea why we do this"?
>> IMO, yes.  It should be noticeable at the very least.
> 
> Added to todo for next spin of these patches.
> 
>>>> 5) I would suggest putting a "remove inpw/outpw pointless wrappers" 
>>>> cleanup patch before patches #2 .. #N.
>>> Next thing on my todo list is to convert the driver over to ioread8 and
>>> friends.  Currently, only the wide boards get accessed through PCIMEM,
>>> but the narrow boards also have PCIMEM BARs.  It would also allow the wide 
>>> boards to be used on machines where PCIMEM is broken, like the VisWS.
>> PCIMEM versus PCIMEM... huh?
> 
> This driver is really two drivers in one -- the wide boards and the
> narrow boards.  Christoph is working on a new driver for the wide boards
> only, and once he's finished that, I'll delete the support for the wide
> boards in this driver.
> 
> Right now, only the wide boards get to take advantage of PCIMEM.  I want
> to give the narrow boards (like the one I have) the opportunity to take
> advantage of PCIMEM, if they have it.  There's also a pending todo for
> wide boards to fall back to ioports if PCIMEM doesn't work.
> 
> If that doesn't answer your question, I need something more detailed
> than "huh?" ;-)

Your earlier statement was just confusing.  You basically said "if 
PCIMEM doesn't work, we should fall back to PCIMEM" if I read it correctly.

I think you meant falling back to ioports, but wanted to clarify.

	Jeff



