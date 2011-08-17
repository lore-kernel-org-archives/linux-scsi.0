From: Bob Zhang <zhanglinbao@gmail.com>
Subject: xen-kernel and EDD
Date: Wed, 17 Aug 2011 13:11:17 +0800
Message-ID: <CAKdQVUb7s6_1RyMDyCkBZWHdAvDy1yPY4nQarqNbSspi4uHC2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40872 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQFLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 01:11:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Cc: Bob Zhang <2004.zhang@gmail.com>

Now , I am using RHEL5.7's xen-kernel, I must add "edd=3Doff" ,
otherwise ,it will print this error :
1706-Smart Array Controller EBDA Memory Corrupted  =A3=ACINT 13h BIOS
Cannot Coninue - Sytem Halted

RHEL said that their RHEL5.7 xen-kernel must make edd off ; while
non-xen kernel doesn't need to make edd off.

why ?
for community XEN developing , is there limit regarding to
EDD(Enhanced Disk Drive)  ?

welcome your comments .thanks .
-Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
