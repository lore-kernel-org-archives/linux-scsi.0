From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/24] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 10:35:46 -0400
Message-ID: <46AA02C2.8010702@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533612-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58206 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760924AbXG0Ofs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:35:48 -0400
In-Reply-To: <11855437533612-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Also, general comment:

To be, or not to be:  CONFIG_PCI and CONFIG_EISA

Even with !CONFIG_FOO handling in the relevant header file, you still 
wind up with dead code being built into the driver.  The !CONFIG_FOO 
behavior remains correct (a no-op), of course.

I don't have an opinion either way.  On one hand, the present setup is 
clean.  On the other hand, you are likely to run into non-ISA platforms 
that might not be happy with building non-PCI code.  It's not the 
eisa_register_driver() that is the problem, but other ISA-specific 
functions you wind up using in the process.

Plus, Andi likes to make a big fuss about building ISA code on x86-64 :)

	Jeff





