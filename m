From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.3.1
Date: Mon, 11 Oct 2004 13:50:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097495416.416a73787e0ae@imp1-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:60562 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S268828AbUJKLuS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 07:50:18 -0400
In-Reply-To: <1097054573.4163b96d1262c@imp5-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.1

Early release, to fix a important i386 breakage due to regparm switch in klibc.
Release focuses on undusting kpartx.
ia64 and woody testers, please redo your thing : I may have got it right this
time.

Full ChangeLog for the release :

        * [kpartx] move back to getopt, originaly removed from the
          original partx because of lack of implementation in klibc
        * [kpartx] don't map extended partitions
        * [kpartx] add a -p command flag to allow admin to force a
          delimiting string between disk name and part number. When
          specified always use it, when unspecified use 'p' as a delim
          when last char of disk name is a digit, NUL otherwise.
        * [kpartx] clean up
        * bump klibc to 0.182
        * one step further : use klibc MCONFIG for all klibc specific
          FLAGS definitions, ie massive Makefile.inc cleanup
        * follow the klibc compilation rules by appending its OPTFLAGS
          to multipath-tools' CFLAGS. This corrects the segfaults seen
          on i386 where klibc is built with regparm=3 and tools are not
        * [multipathd] fall back to fork when clone not available
          like in Debian Woody
        * [kpartx] move .start and .size from uint to ulong (Ake)
        * briefly document system-disk-on-multipath in the FAQ file

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
--
christophe varoqui <christophe.varoqui@free.fr>
