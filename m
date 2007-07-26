From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/21] advansys: Clean up proc_info implementation
Date: Thu, 26 Jul 2007 13:05:46 -0600
Message-ID: <20070726190546.GM19275@parisc-linux.org>
References: <1185470577359-git-send-email-matthew@wil.cx> <46A8ED47.6030909@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39977 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761357AbXGZTFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 15:05:47 -0400
Content-Disposition: inline
In-Reply-To: <46A8ED47.6030909@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 02:51:51PM -0400, Jeff Garzik wrote:
> Not a _bug_ per se, but the above useless patch chunk seems to have 
> leaked into this patch.

Weird.  Those lines are deleted later in this patch series anyway, so
I don't intend to worry about this problem unless I respin the patch
series.  Thanks for pointing it out though.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
