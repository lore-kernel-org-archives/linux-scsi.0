From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: build #312 failed for 2.6.23-rc1-g1ed4395 in linux/drivers/scsi/advansys.c
Date: Thu, 2 Aug 2007 05:31:56 -0600
Message-ID: <20070802113156.GH21219@parisc-linux.org>
References: <200708021313.48698.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35966 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXHBLb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 07:31:57 -0400
Content-Disposition: inline
In-Reply-To: <200708021313.48698.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf F?rster <toralf.foerster@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2007 at 01:13:45PM +0200, Toralf F?rster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'

We just went over this with Gabriel C.  Please try applying all these
patches:

http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-30/

or just pull from this git tree:

http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=shortlog

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
