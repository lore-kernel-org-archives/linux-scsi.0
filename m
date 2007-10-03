From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 14/21] advansys: Get rid of board index number
Date: Tue, 02 Oct 2007 22:04:39 -0400
Message-ID: <4702F8B7.5010606@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765433253-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41937 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXJCCEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:04:41 -0400
In-Reply-To: <11913765433253-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> It's always a mistake to have your own index of boards; just use the
> scsi host number.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK, though the "return;" cleanup is large enough to warrant a separate 
patch, or at the very least, deserves a mention in the patch description.


