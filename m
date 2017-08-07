From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/29] constify scsi pci_device_id.
Date: Mon, 07 Aug 2017 13:28:18 -0400
Message-ID: <yq1tw1j9tjh.fsf@oracle.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
        <20170731075647.GB4316@linux-x5ow.site>
        <6b6ba203-1352-26ed-8d7e-c14e7bb25d32@gmail.com>
        <20170731092753.GB6417@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29252 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdHGRaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:30:20 -0400
In-Reply-To: <20170731092753.GB6417@linux-x5ow.site> (Johannes Thumshirn's
        message of "Mon, 31 Jul 2017 11:27:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Johannes,

> Ultimately it's up to Martin and James but I don't see a hughe benefit
> in having it all in a separate patch.

Generally speaking, I prefer driver maintainers to be able to sign off
on changes to their code. So I tend to lean towards a per-driver
grouping.

However, having a bazillion identical commit messages is also really
annoying. So for automated changes like this, I'd rather just have a
single patch.

It needs to have a really good and comprehensive commit messages that
justifies the (sub) tree-wide change, though...

-- 
Martin K. Petersen	Oracle Linux Engineering
