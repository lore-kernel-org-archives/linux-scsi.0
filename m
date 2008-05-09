From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: lsscsi is broken
Date: Fri, 9 May 2008 16:38:15 -0700
Message-ID: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:64917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981AbYEIXiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 19:38:15 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1802256rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2008 16:38:15 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

LBSuse:~ # lsscsi
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
[target0:0:0]type?   vendor?  model?           rev?  -
[target1:0:0]type?   vendor?  model?           rev?  -
[target2:0:0]type?   vendor?  model?           rev?  -
[target3:0:0]type?   vendor?  model?           rev?  -
[target6:0:0]type?   vendor?  model?           rev?  -
[target7:0:0]type?   vendor?  model?           rev?  -
[target8:0:0]type?   vendor?  model?           rev?  -
[target9:0:0]type?   vendor?  model?           rev?  -
[target12:0:0]type?   vendor?  model?           rev?  -
[0:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[1:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[2:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[3:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[6:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[7:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[8:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[9:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
[12:0:0:0]   cd/dvd  TSSTcorp CD/DVDW TS-T632A SR03  -


Linux LBSuse 2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty
#372 SMP Thu May 8 18:54:33 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux
