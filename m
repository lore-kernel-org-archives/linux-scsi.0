From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.2.1
Date: Thu,  3 Jun 2004 11:52:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086256342.40bef4d61b3e9@imp3-q.free.fr>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:8074 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S263629AbUFCJwX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 05:52:23 -0400
In-Reply-To: <1084519750.40a47546dd0e6@imp1-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org

Hello,

here goes multipath-tools-0.2.1

This is a fairly big update which address all the problems reported so far and
includes patchs from a greater number of testers. I'm quite happy to see it
mostly works for a wide variety of hardware (server arch and storage).
Anyway, it still needs more beating. Specificaly on EMC hardware, to which I
don't have access.

Changelog for this release :

        * [multipath] add a flag to inihibit the final SIGHUP to
          multipathd. Needed to avoid recursion with the correction
          below
        * [multipathd] devmap event now triggers a multipath exec
          in addition to the usual updatepaths()
        * [multipathd] move checkers from sg_io on BLK onto CHR
          readsector0 goes from read to sg_read
        * [multipathd] rely on sysfs for failedpaths enum and no
          longer on the device mapper
        * [multipathd] convert get_lun_strings from ioctl to sysfs
          so we can benefit from strings persistency for failed
          paths
        * [multipath] readconfig() to take only 8 char from vendor
          string (ake)
        * [multipath] remove unecessery and wrong getuid == NULL
          check from devinfo() (ake)
        * [multipathd] make readsector0 open path O_DIRECT
        * [multipathd] sizeof(path) -> sizeof(struct path) (MikeC)
        * [Makefile] don't try to install and uninstall libs
        * [devmap_name] kill the wrong trailing '\n'
          (Mike Christie)
        * [kpartx] works with device nodes outside /dev
        * [kpartx] correctly display the delimiter in partition
          name outputs

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui
