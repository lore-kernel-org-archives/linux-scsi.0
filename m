From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 16:19:51 +0900
Message-ID: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56547 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S261283AbVCAHT4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 02:19:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: iscsitarget-devel@lists.sourceforge.net

Hi,

I would like to announce the iSCSI enterprise target (IET) software,
which is open-source software to build iSCSI storage systems. It can
provide disk volumes to iSCSI initiators by using any kinds of files
(regular files, block devices, virtual block devices like RAID and
LVM, etc). The project was started by forking the Ardis target
implementation (http://www.ardistech.com/iscsi/) about one year
ago. The source code and further information are available from:

http://iscsitarget.sourceforge.net/

The user-space daemon handles authentication and the kernel threads
take care of network and disk I/O requests from initiators by using
the VFS interface. The kernel-space code is not intrusive. It doesn't
touch other parts of the kernel. The code is already stable and
usable. More than 130 people currently subscribe to the project's
mailing list. The developers aim for inclusion into the mainline
kernel.

The latest code against 2.6.11-rc5 for review can be found at:

http://zaal.org/iscsi/iet/0.4.6/r996.tar.gz

Could you please review the code? Any comments are greatly
appreciated.
