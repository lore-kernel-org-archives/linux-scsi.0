From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Fw: scsi_wait_scan Kconfig option
Date: Fri, 7 Dec 2007 12:47:56 -0700
Message-ID: <20071207194756.GB28914@parisc-linux.org>
References: <20071207193953.0c544044@linuxamd.linicks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48544 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXLGTr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 14:47:57 -0500
Content-Disposition: inline
In-Reply-To: <20071207193953.0c544044@linuxamd.linicks.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Warne <nick@ukfsn.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 07, 2007 at 07:39:53PM +0000, Nick Warne wrote:
> I try not to build a modular kernel, but only have modules ON due to
> nVidia (sigh).  So I was semi-surprised when I saw the scsi_wait_scan
> module being built again, yet NO WHERE in menuconfig is it present to
> turn OFF.  Even if I hand edit .config, make puts it back again...

You have modules on ... which means you might decide to load a scsi
driver as a module.  Maybe one that isn't part of the source tree.
The scsi_wait_scan module is only 1500 bytes.  Apart from a sense of
ideological purity (odd in someone who chooses to use nVidia rather
than, say, nv or nouveau), this really isn't a problem.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
