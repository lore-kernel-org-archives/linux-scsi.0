From: Michal Kepien <lordpopcorn@poczta.onet.pl>
Subject: Kernel migration: 2.4.7-10 -> 2.4.19 - different filenames on the CD
Date: Thu, 03 Jul 2003 18:12:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <vjk8gvkkns3sk8h9qfs978ak0qmmkou504@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.poczta.onet.pl ([213.180.130.31]:36048 "EHLO
	smtp1.poczta.onet.pl") by vger.kernel.org with ESMTP
	id S264432AbTGCP6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 11:58:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there. I've got a problem with migrating to kernel 2.4.19. I've got
a Creative CD-ROM and an LG CD-RW drive. I'm writing to this list
because the second drive (CD-RW) is using SCSI emulation (/dev/cdrom1
-> /dev/scd0). So, here's the story.

When I was using the stack 2.4.7-10 kernel (RH 7.2 Enigma), everything
worked fine and the filenames on the mounted CDs were read correctly,
(e.g. directory name: 'Linux kernel 2.4.19', file name:
'linux-2.4.19.tar.gz'). Since I upgraded the kernel to version 2.4.19,
the drives work correctly as well, but the file and directories name
are different (for the examples above: directory name: 'linux kernel
24.19', file name: 'linux-2419tar.gz').

When I, for example, copy the archive mentioned above to the hard
disk, change the extension (there is no '.' before 'tar.gz') and run
the extraction command, it works OK. However, it is strange for me
that such a weird change in names happened.

Could you tell me what can possibly cause this and how to correct the
error? It's not a big problem, but I like when everything works just
as I want :)

Thanks for your help,
Michal Kepien


-- 
Lord Popcorn
lordpopcorn@poczta.onet.pl

"The UPL leaders formulated a bold plan that would assure that humanity would persevere, unscathed by the tempting corruption of radical technologies." --- Blizzard Ent.
