From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lpfc sleeps while holding a spinlock
Date: Thu, 9 Oct 2008 11:19:52 -0600
Message-ID: <20081009171951.GY25780@parisc-linux.org>
References: <20081009164101.GX25780@parisc-linux.org> <48EE3643.9040607@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42913 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYJIRUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2008 13:20:08 -0400
Content-Disposition: inline
In-Reply-To: <48EE3643.9040607@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Oct 09, 2008 at 12:50:11PM -0400, James Smart wrote:
> We already fixed this in the 8.2.8 patches that were sent and are 
> sitting in James's git pools. Specifically, see patch8:
> http://marc.info/?l=linux-scsi&m=121962902731358&w=2

Looks like a fine way to avoid the problem.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
