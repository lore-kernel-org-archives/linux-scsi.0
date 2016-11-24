From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: UFS_MASK macro definition
Date: Thu, 24 Nov 2016 11:23:48 +0800
Message-ID: <CAMj5Bkgp59xuPRCPq8NGBPjG4ep6qb-DkjzUzPi7cWeVxSJrYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:34737 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcKXDXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 22:23:50 -0500
Received: by mail-qt0-f171.google.com with SMTP id n6so29540949qtd.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 19:23:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org

Hi, Vinayak

Checked 4.9-rc6, and not find UFS_MASK macro definition.
Have find this patch from google,

http://www.spinics.net/lists/linux-scsi/msg58634.html
[PATCH 2/2] [SCSI] ufs: Add missing UFS_MASK macro definition

Is this patch has been merged?

There will be build error if some definition defined by UFS_MASK is used.
Otherwise it may keep silent.

Thanks
