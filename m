From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: bnx2i + bnx2fc: convert to generic workqueue (#2)
Date: Tue, 22 Nov 2016 18:48:08 +0100
Message-ID: <20161122174813.16184-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60407 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933714AbcKVRsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 12:48:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

This is the a repost + fixups to get the patches applied against v4.9-rc4.
mkp's scsi for-next tree can be merged with no conflicts.

The last repost was not merged and stalled after Chad Dupuis said to hold on
because he is testing but never came back with the results [0]. Johannes
confirmed that he did some testing of bnx2fc but he is not sure about bnx2i
[1]. hch asked later about something different but wanted them in since they
were tested as-is [2]. And now I renamed kworker to workqueue as requested =
by
hch [3].

The whole series is also available at
 git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/hotplug-staging.git =
scsi/bnx2

[0] https://lkml.kernel.org/r/yq137l2mm13.fsf@sermon.lab.mkp.net
[1] https://lkml.kernel.org/r/20161108072434.gnnhmrkkmxroy6dv@linux-x5ow.si=
te
[2] https://lkml.kernel.org/r/20161107191025.GA5357@lst.de
[3] https://lkml.kernel.org/r/20161118145504.GA9405@lst.de

Sebastian

