From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 16 Aug 2017 20:10:50 -0400
Message-ID: <yq1k223qcj9.fsf@oracle.com>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
        <1502461401-94630-3-git-send-email-hare@suse.de>
        <yq18tilwmax.fsf@oracle.com>
        <dd9d797a-ec8e-7395-6d7c-068c4ece08d0@suse.de>
        <1502837223.2259.15.camel@wdc.com>
        <b4309af8-210b-04e1-e541-f58455fc4bc1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41350 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdHQAME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:12:04 -0400
In-Reply-To: <b4309af8-210b-04e1-e541-f58455fc4bc1@suse.de> (Hannes Reinecke's
        message of "Wed, 16 Aug 2017 07:56:19 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>


Hannes,

> I still would like to keep the above, as the admin can feed blacklist
> flags via the kernel commandline, and we don't do any validity checks on
> that. So we might end up with invalid flags after all.

I suggest you handle this by printing something along the lines of
"INVALID_BIT_SET(42)" for each bad flag.

Also: Brownie points for adding a new sysfs interface to augment the
existing /proc goo for adding entries. Preferably one that takes BLIST
names instead of huge hex numbers.

-- 
Martin K. Petersen	Oracle Linux Engineering
