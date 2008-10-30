From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 0/9] osdfs
Date: Thu, 30 Oct 2008 16:26:34 +0200
Message-ID: <4909C41A.7000406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1887 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754784AbYJ3O0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 10:26:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Please review an OSD based file system. 

Given that our OSD initiator library is accepted into Kernel, we would
like to also submit an osdfs. This is the first iteration of this file system.

The next stage is to make it exportable by the pNFS-over-objects Server.
osdfs is one of the building blocks for a full, end-to-end open source
reference implementation of a Server/Client pNFS-over-objects we
want to have available in Linux. Other parts are the Generic pNFS
client project with the objects-layout-driver, and the generic pNFS
server plus osdfs once it is adapted to be exportable.
(See all about pNFS in Linux at:
http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design)

osdfs was originally developed by Avishay Traeger <avishay@gmail.com>
from IBM. A very old version of it is hosted on sourceforge as the osdfs
project. It was originally developed for the 2.6.10 Kernel over the old
IBM's osd-initiator Linux driver.

Since then it was picked by us, open-osd, and was both forward ported to
current Kernel, as well as converted to run over our osd Kernel Library.
The conversion effort, if anyone is interested, is also available as a
patchset here:
  git-clone git://git-open-osd.org/open-osd.git osdfs-devel
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/osdfs-devel

The Original code is based on ext2 code from the Kernel at the time.
Further reading is available at the last patch in the osdfs.txt file.

I have mechanically divided the code in parts, each introducing a
group of vfs function vectors, all tied at the end into a full filesystem.
Each patch can be compiled but it will only run at the very end.
This was done for the hope of easier reviewing.

Here is the list of patches
[RFC 1/9] osdfs: osd Swiss army knife
[RFC 2/9] osdfs: file and file_inode operations
[RFC 3/9] osdfs: symlink_inode and fast_symlink_inode operations
[RFC 4/9] osdfs: address_space_operations
[RFC 5/9] osdfs: dir_inode and directory operations
[RFC 6/9] osdfs: super_operations and file_system_type
[RFC 7/9] osdfs: mkosdfs
[RFC 8/9] osdfs: Documentation
  Patches to be submitted

[PATCH 9/9] [out-of-tree] open-osd: Global Makefile and do-osdfs test script
  This patch will not be submitted. It is only needed if compiling
  out-of-tree. One more patch that is missing from this patchset is the
  patch to Kernel's fs/Makefile fs/Kconfig and Documentation/filesystems/00-INDEX.

This patchset is also available on:
  git-clone git://git-open-osd.org/open-osd.git osdfs
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/osdfs
 
If anyone wants to actually run this code and test it
then please start here: http://open-osd.org
and also the osdfs.txt file at last patch should help

Thanks in advance
Boaz

