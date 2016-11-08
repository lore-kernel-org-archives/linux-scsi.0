From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Ordering problems with 3ware controller
Date: Tue, 08 Nov 2016 18:45:48 -0500
Message-ID: <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51701 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbcKHXqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 18:46:11 -0500
In-Reply-To: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de> (Paul
        Menzel's message of "Tue, 8 Nov 2016 11:07:37 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@lsi.com>

>>>>> "Paul" == Paul Menzel <pmenzel@molgen.mpg.de> writes:

Paul,

Paul> Updating from Linux 4.4.X to Linux 4.8.4, we noticed that the
Paul> 3ware devices under `/dev` – `/dev/twa0`, `/dev/twa1`, … – map to
Paul> the controllers differently.

Paul> This unfortunately breaks quite a lot of our scripts, as we depend
Paul> on the fact that the first controller is also in the front.

It's not the 3ware drivers since they have not been updated in a long
time (since way before 4.4).

Linux does not provide device discovery ordering guarantees. You need to
fix your scripts to use UUIDs, filesystem labels, or DM devices to get
stable naming.

-- 
Martin K. Petersen	Oracle Linux Engineering
