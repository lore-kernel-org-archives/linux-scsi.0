From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Ordering problems with 3ware controller
Date: Thu, 10 Nov 2016 08:59:21 -0500
Message-ID: <yq11syjo2py.fsf@sermon.lab.mkp.net>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
        <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
        <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40004 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbcKJN7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 08:59:34 -0500
In-Reply-To: <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de> (Paul
        Menzel's message of "Wed, 9 Nov 2016 10:08:37 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, dvteam@molgen.mpg.de

>>>>> "Paul" == Paul Menzel <pmenzel@molgen.mpg.de> writes:

Paul,

>> Linux does not provide device discovery ordering guarantees. You need
>> to fix your scripts to use UUIDs, filesystem labels, or DM devices to
>> get stable naming.

Paul> Indeed. But it worked for several years, so that *something* must
Paul> have changed that the ordering of the result of `getdents64` is
Paul> different now.

Could be changes in the PCI or platform code that causes things to be
enumerated differently. Whatever it is, it has nothing to do with the
3ware drivers themselves since they have been dormant for a long time.

Paul> Fixing the scripts is unfortunately not that easy, as `tw_cli` is
Paul> a proprietary tool [1], and we do not have the sources. It does a
Paul> `readdir()`.

That's beside the point. Whatever you are doing that needs to address a
specific physical controller needs to use a different scheme than
discovery order to do so. Don't know if these cards provide a device
identification VPD or something with a serial number that you could key
off of?

-- 
Martin K. Petersen	Oracle Linux Engineering
