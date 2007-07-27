From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 13/24] advansys: misc reformatting
Date: Fri, 27 Jul 2007 10:42:50 -0400
Message-ID: <46AA046A.8000200@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533064-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58316 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761374AbXG0Omw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:42:52 -0400
In-Reply-To: <11855437533064-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Remove some useless forward declarations
> Reformat some comments, debug messages, and the occasional piece of real code
> Removal of unnecessary braces
> Remove duplicate setting of shost->irq

dumb question:  why set shost->irq at all?


