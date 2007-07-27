From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 21/21] advansys: use memcpy instead of open-coded loop
Date: Thu, 26 Jul 2007 22:58:18 -0600
Message-ID: <20070727045817.GA21219@parisc-linux.org>
References: <11854705773144-git-send-email-matthew@wil.cx> <46A8FB15.5070103@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33716 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXG0E6T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 00:58:19 -0400
Content-Disposition: inline
In-Reply-To: <46A8FB15.5070103@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 03:50:45PM -0400, Jeff Garzik wrote:
> Done with my review.  Any patches I did not comment on can be considered 
> sane...

Thanks, Jeff, that was a Herculean effort.  I've gone through and
made most of your suggested changes.  I'm making too many mistakes now,
so it's time to go to bed, but I'll post another round of patches early
tomorrow.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
