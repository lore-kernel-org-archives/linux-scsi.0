From: Yagmur Oymak <yagmur.oymak@gmail.com>
Subject: 4.12 NULL pointer dereference in kmem_cache_free on USB storage
 removal
Date: Sat, 22 Jul 2017 11:58:16 +0300
Message-ID: <726b4c5d-610d-4d74-28e3-bfbc4fad06e0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35825 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752127AbdGVI6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2017 04:58:25 -0400
Received: by mail-wr0-f193.google.com with SMTP id c24so10145153wra.2
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2017 01:58:24 -0700 (PDT)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Hello,

This problem was reported in the linux-kernel list, here:
https://lkml.org/lkml/2017/7/13/710, and it is said that commit
8e6882545d8c ("scsi: Avoid
that scsi_exit_rq() triggers a use-after-free") fixes it. It indeed
fixes it as the problem does not exist on 4.13-rc1 (which includes the
commit) and on 4.12.x if the patch is applied. However, none of the 4.12
releases since that discussion includes the patch, so the problem is
still there. Can that be included in the next stable release?

Thanks,
Yagmur Oymak
