From: Matthew Wilcox <matthew@wil.cx>
Subject: Advansys driver
Date: Thu, 26 Jul 2007 11:11:41 -0600
Message-ID: <20070726171141.GE19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47329 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761664AbXGZRLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 13:11:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Since the AdvanSys driver hasn't had a maintainer in 6 years, I don't
think anybody's going to seriously object to me taking this on.

I present a git tree of patches:
http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=summary

and the broken-out version of those patches:
http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-26/

There's no way I'm going to send the Lindenting of that driver to the
list; it's 1.1MB.  Here's the git-log entry for it:

    advansys: Large, uninteresting changes
    
     - Run Lindent
     - Move advansys_detect and advansys_release to the end of the file
     - Split advansys_board_found out of advansys_detect
     - Rename a few variables, such as shp to shost and pci_devp to pdev
     - Turn STATIC into static

I'll send the other 21 patches as a reply to this mail.

I'd like to particularly thank Ken Witherow for testing many different
versions of these patches.  He was indefatigable in the presence of
the daft changes I was making when I didn't have a card to test it on.
I would thank Dave Jones for sending me his card, but I think he did it
to get revenge on me for something :-)

If anyone has an EISA version of this card they want to donate to me,
I can give it a good home in an Alpha.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
