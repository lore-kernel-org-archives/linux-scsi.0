From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 02/17] PCI Error Recovery: Symbios SCSI base support
Date: Tue, 2 Oct 2007 15:49:26 -0600
Message-ID: <20071002214926.GY12049@parisc-linux.org>
References: <200710022138.l92Lc0sG023555@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51471 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbXJBVt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:49:28 -0400
Content-Disposition: inline
In-Reply-To: <200710022138.l92Lc0sG023555@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linas@austin.ibm.com, willy@debian.org

On Tue, Oct 02, 2007 at 02:38:00PM -0700, akpm@linux-foundation.org wrote:
> From: Linas Vepstas <linas@austin.ibm.com>
> 
> Various PCI bus errors can be signaled by newer PCI controllers.  This
> patch adds the PCI error recovery callbacks to the Symbios SCSI device
> driver.  The patch has been tested, and appears to work well.

Linas and I have been discussing the problems with this patch.  I think
we have a solution; we certainly have something in my tree that's
acceptable to me; he'd jus like to test it before it's unleashed on the
world.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
