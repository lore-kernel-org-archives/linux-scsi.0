From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
Date: Thu, 25 Oct 2007 05:22:31 -0600
Message-ID: <20071025112231.GL27248@parisc-linux.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52812 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXJYLWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 07:22:33 -0400
Content-Disposition: inline
In-Reply-To: <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, kkeil@suse.de

On Thu, Oct 25, 2007 at 04:06:15AM -0400, Jeff Garzik wrote:
> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
> not properly converted to the DMA API
> 
> ...represent conditions that have existed for years, and are duly noted
> in FIXMEs.  There does not seem to be much need to warn on every kernel
> build for a driver bug or handicap that has existed for years.

I'll be removing this #warning from advansys when I get rid of the
last bus_to_virt.  Which I've already done ... it's just that the
resulting driver works on i386, but crashes parisc, so there's clearly a
bug.  I haven't had time to track it down yet.  So NACK this patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
