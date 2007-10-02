From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 12/17] advansys printk fix
Date: Tue, 2 Oct 2007 15:52:06 -0600
Message-ID: <20071002215206.GA12049@parisc-linux.org>
References: <200710022138.l92Lc9Zp023591@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58053 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXJBVwH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:52:07 -0400
Content-Disposition: inline
In-Reply-To: <200710022138.l92Lc9Zp023591@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Oct 02, 2007 at 02:38:09PM -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Fix this:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:16320: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'
> 
> and clean the code up a little.

This'll conflict with a few of the patches in my tree; I have fixed the
warning ... James, any intent to merge the most recent series of patches
I sent?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
