From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 17/21] advansys: Remove DvcGetPhyAddr
Date: Tue, 02 Oct 2007 22:13:47 -0400
Message-ID: <4702FADB.4010507@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376543243-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37421 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXJCCNt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:13:49 -0400
In-Reply-To: <1191376543243-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> This rather complex function boiled down to calling virt_to_bus().
> Also get rid of some obsolete defines and variables that could never vary.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK


