From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4/24] advansys: Make advansys_board_found a little more readable
Date: Fri, 27 Jul 2007 08:07:21 -0600
Message-ID: <20070727140720.GD21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <1185543753768-git-send-email-matthew@wil.cx> <46A9FB83.4010901@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41465 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbXG0OHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:07:22 -0400
Content-Disposition: inline
In-Reply-To: <46A9FB83.4010901@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:04:51AM -0400, Jeff Garzik wrote:
> Regardless of the original code, it is quite irregular to force the 
> caller to clean up after advansys_wide_init_chip() kmalloc failure.  I 
> could understand it, perhaps, if err_free_wide_mem label was used more 
> than once, but it's not.

It is ... in the next patch.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
