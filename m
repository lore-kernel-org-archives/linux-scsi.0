From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI support broken in latest 2.4 kernel
Date: Tue, 24 Jul 2007 05:26:06 -0600
Message-ID: <20070724112605.GG26883@parisc-linux.org>
References: <1185266014.28815.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41025 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762039AbXGXL0H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 07:26:07 -0400
Content-Disposition: inline
In-Reply-To: <1185266014.28815.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abdelrahman <estr4ng3d@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 24, 2007 at 11:33:33AM +0300, Abdelrahman wrote:
> It seems impossible to compile the latest 2.4.35.6 kernel with the
> scsi_mod module and produce a usable system. I have used the attached
> config file and the normal compile procedure (make dep; make bzImage;
> make modules) and ended up with unloadable modules (unresolved symbols).
> I have tried both gcc 3.3 and 4.1. The same issue exists in at least
> 2.4.27 as well.
> 
> Please advise if I can provide any further information which would aid
> in resolution.

Which symbols?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
