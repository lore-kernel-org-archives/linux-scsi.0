From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: Excluding unknown partition tables
Date: Tue, 24 Sep 2002 08:40:39 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD5BAE@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aruba ([198.164.225.65]) by ebony.nbnet.nb.ca
          (Post.Office MTA v3.5.3 release 223 ID# 0-0U10L2S100V35)
          with SMTP id ca for <linux-scsi@vger.kernel.org>;
          Tue, 24 Sep 2002 08:37:24 -0300
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Can messages such as this "unknown partition table" entry in /var/log be somehow filtered:

<...snip...>
SCSI subsystem driver Revision: 1.00
Red Hat/Adaptec aacraid driver, May  3 2002
<...snip...>
SCSI device sdb: 15360 512-byte hdwr sectors (8 MB)
 sdb: unknown partition table
<...snip...>

I'm wondering if it's possible to exclude certain devices from being scanned, and if it can be done without too much coding involved.

Marco
