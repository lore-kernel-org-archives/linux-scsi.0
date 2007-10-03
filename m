From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 11/21] advansys: Remove library version & serial numbers
Date: Tue, 02 Oct 2007 22:14:42 -0400
Message-ID: <4702FB12.7010006@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376542497-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37430 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXJCCOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:14:44 -0400
In-Reply-To: <1191376542497-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> With the ASC and ADV libraries merged into the driver, there really is
> no point in reporting their version numbers, or even trying to maintain
> them.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

It would be real nice if those printk's started growing KERN_xx prefixes

ACK


