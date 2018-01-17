From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Wed, 17 Jan 2018 17:13:11 +0100
Message-ID: <6228d70f-e720-4706-b79b-efc6fb406ad0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35272 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753860AbeAQQNP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 11:13:15 -0500
Received: by mail-wr0-f194.google.com with SMTP id g38so16256362wrd.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2018 08:13:15 -0800 (PST)
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Sebastian Parschauer <sparschauer@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, ETERNUS Japan <eternus-contact@cs.jp.fujitsu.com>

Martin Wilck wrote:

> On Wed, 2018-01-17 at 01:15 -0500, Martin K. Petersen wrote:
>> 
>> > +		if (!strncmp(scmd->device->vendor, "FUJITSU", 7)
>> > &&
>> > +			   !strncmp(scmd->device->model,
>> > "ETERNUS_DXM", 11) &&

Is DXM the S3 family?

>> Blacklist, please.
> 
> To make sure I understand correctly:
> 
> You'd like to spend a precious BLIST bit for this single device which
> uses vendor-specific ASC/Q?


A similar patch for SYMMETRIX was rejected recently:
https://marc.info/?t=150822433400007


BTW, a BLIST patch for ETERNUS DXL (S2???) is also needed:
http://kernel.suse.com/cgit/kernel-source/plain/patches.fixes/scsi_scan-Send-TEST-UNIT-READY-to-LUN0-before-LUN-sc.patch?h=SLE15
