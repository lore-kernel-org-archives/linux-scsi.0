From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 13/21] advansys: Remove private lock
Date: Tue, 02 Oct 2007 22:09:32 -0400
Message-ID: <4702F9DC.104@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765433063-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38697 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbXJCCJd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:09:33 -0400
In-Reply-To: <11913765433063-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> The board lock was essentially identical with the host lock.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK, though the s/spin_lock_irqsave/spin_lock/ in the interrupt handler 
deserves a mention in the patch description


