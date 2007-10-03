From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 03/21] advansys: Restructure asc_execute_scsi_cmnd()
Date: Tue, 02 Oct 2007 22:17:58 -0400
Message-ID: <4702FBD6.7090502@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765423260-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37460 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbXJCCSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:18:00 -0400
In-Reply-To: <11913765423260-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> The wide and narrow boards share identical handling of the return value,
> except for some trivial error messages.  Move the handling to the common
> end of the function.  Also move variable declarations to the arms of
> the `if' that they're used in and delete some pointless comments.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK


