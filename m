From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.6.0-test9: scsi_dev_flags
Date: Sun, 26 Oct 2003 08:38:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031026083850.A15515@beaverton.ibm.com>
References: <20031026144741.A4326@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:52689 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263280AbTJZQjl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2003 11:39:41 -0500
Content-Disposition: inline
In-Reply-To: <20031026144741.A4326@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Sun, Oct 26, 2003 at 02:47:41PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 26, 2003 at 02:47:41PM +0000, Russell King wrote:

> So, I then tried doing exactly that:
> 
> 	scsi_dev_flags=SyQuest:SQ3270S:4096

If that is the kernel boot line, you need to prefix the argument with
scsi_mod., i.e. scsi_mod.scsi_dev_flags=, per the module_param
interface(s).

> An additional question comes out from this - if quirk information is now
> to be passed on the kernel command line, how are users supposed to work
> out the correct command line argument to give for their quirky hardware
> given that it doesn't appear to be as trivial as the code suggests?
> (IOW, the scsi_dev_flags option appears to be rather undocumented!)

There is a bit in Documentation/kernel-parameters.txt, but there should be
more documentation added somewhere. Also the integer value can be hex
(0x1000).

-- Patrick Mansfield
