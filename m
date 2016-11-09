From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
Date: Tue, 08 Nov 2016 21:28:48 -0500
Message-ID: <yq1h97hpesf.fsf@sermon.lab.mkp.net>
References: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk>
        <yq1mvh9r2b9.fsf@sermon.lab.mkp.net>
        <48f84d6c60f7ac70928c2cb34cd2ed1f@mail.gmail.com>
        <7829000d-2e1c-d298-57cb-8d02c4e020d2@kernel.dk>
        <802c0d7b475ef619f6fb4aaeef7f138d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26992 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbcKICaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 21:30:02 -0500
In-Reply-To: <802c0d7b475ef619f6fb4aaeef7f138d@mail.gmail.com> (Kashyap
        Desai's message of "Wed, 9 Nov 2016 07:44:15 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

>> Send a fix on top of current -git asap. The current tree is
>> completely broken for any megaraid user. -rc4 is no time to send in
>> untested patches, especially not something that claims to fix a 9
>> year old bug and is marked for stable as well.

*sigh* It's always the most innocuous patches that cause the worst
regressions :(

Kashyap> I will run some more test (using patch set only marked for
Kashyap> stable from last series) and submit fix ASAP.

I just tried a system with a megaraid card and things are broken in both
4.9/scsi-fixes and 4.10/scsi-queue unless the controller firmware has
the new sync flag set.

So, yes. Let's get a fix for this queued up ASAP.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
