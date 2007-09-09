From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Sun, 09 Sep 2007 11:29:34 -0400
Message-ID: <46E4115E.7050203@garzik.org>
References: <20070909145358.GG6809@parisc-linux.org> <11893498072821-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45134 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481AbXIIP3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Sep 2007 11:29:36 -0400
In-Reply-To: <11893498072821-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Matthew Wilcox wrote:
> Rearrange a lot of the functions in the file to get rid of all the forward
> declarations.

What thoughts, if any, have been given to post-patch code arrangement, 
besides eliminating prototypes?

This always struck me as a counterproductive exercise when taken by 
itself.  Sure, prototypes were eliminated, but was code packed together 
in an efficient way afterwards?  Ideally hot path code should be close 
together, ditto for various other things like error handling code.

Without further explanation or details about your post-patch analysis, 
how do we even know the new code arrangement doesn't negatively impact 
i-cache overall?

	Jeff


