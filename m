From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] fcoe: provide translation table between Ethernet and FC port speeds
Date: Tue, 23 Aug 2016 22:28:32 -0400
Message-ID: <yq18tvmew8f.fsf@sermon.lab.mkp.net>
References: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16730 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753563AbcHXC3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2016 22:29:19 -0400
In-Reply-To: <1471613617-21291-1-git-send-email-jthumshirn@suse.de> (Johannes
        Thumshirn's message of "Fri, 19 Aug 2016 15:33:37 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> Provide a translation table between Ethernet and FC port
Johannes> speeds so odd speeds (from a Ethernet POV) like 8 Gbit are
Johannes> correctly mapped to sysfs and open-fcoe's fcoeadm.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
