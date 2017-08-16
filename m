From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Tue, 15 Aug 2017 22:03:02 -0400
Message-ID: <yq1bmngtgkp.fsf@oracle.com>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
        <1502461401-94630-3-git-send-email-hare@suse.de>
        <1502807056.2900.1.camel@wdc.com>
        <b9248f72-1278-b02c-6835-39d505673c1f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20296 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdHPCDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2017 22:03:31 -0400
In-Reply-To: <b9248f72-1278-b02c-6835-39d505673c1f@suse.de> (Hannes Reinecke's
        message of "Tue, 15 Aug 2017 16:40:11 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>


Hannes,

>> Wouldn't debugfs be more appropriate for this attribute than sysfs?
>> 
> I so don't mind.
> I just need it somewhere in sysfs/debugfs so that I can validate the
> selection logic.
>
> Same goes for hexvalue vs decoded output; I just need to attribute;
> contents can be discussed.

I don't have a problem having it in sysfs. We have several users that
tweak the device blacklist in their boot scripts

Given that we already have an interface for setting the flags, we might
as well be able to print them.

-- 
Martin K. Petersen	Oracle Linux Engineering
