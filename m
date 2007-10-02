From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 11/17] Fix section mismatch in the Adaptec DPT SCSI Raid driver
Date: Tue, 2 Oct 2007 15:50:38 -0600
Message-ID: <20071002215038.GZ12049@parisc-linux.org>
References: <200710022138.l92Lc89D023588@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58048 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbXJBVuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:50:39 -0400
Content-Disposition: inline
In-Reply-To: <200710022138.l92Lc89D023588@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, joe.korty@ccur.com, aacraid@adaptec.com, willy@debian.org

On Tue, Oct 02, 2007 at 02:38:08PM -0700, akpm@linux-foundation.org wrote:
> From: Joe Korty <joe.korty@ccur.com>
> 
> Fix section mismatch in the Adaptec DPT SCSI Raid driver.

Acked-by: Matthew Wilcox <willy@linux.intel.com>

> Mathew: isn't a module exit routine a little too strong to be calling on the
> failure of a single device?  Module exit implies that other, non-failing
> adaptec raid devices will also get shut down.  

It's what the original driver did.  Feel free to propose a better
alternative ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
