From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Tue, 15 Aug 2017 22:09:52 -0400
Message-ID: <yq17ey4tg9b.fsf@oracle.com>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
        <1502461401-94630-3-git-send-email-hare@suse.de>
        <yq18tilwmax.fsf@oracle.com>
        <dd9d797a-ec8e-7395-6d7c-068c4ece08d0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752130AbdHPCKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2017 22:10:17 -0400
In-Reply-To: <dd9d797a-ec8e-7395-6d7c-068c4ece08d0@suse.de> (Hannes Reinecke's
        message of "Tue, 15 Aug 2017 10:03:50 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

>> It seems this else statement facilitates papering over the fact that
>> scsi_sysfs.c and scsi_devinfo.h can get out of sync.

> But there is no good way of avoiding that, is there?
> Out of necessity the definition of the bits and the decoding are two
> distinct steps, and as such are always prone to differences.
>
> So what is your suggestion here?

I was merely fishing for comments being added to both files stating that
it was important to keep them in sync.

However, if you can automate it using Bart's approach, stringify magic
or something else then that's cool. We have several places where
something like that would be useful.

-- 
Martin K. Petersen	Oracle Linux Engineering
