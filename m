From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 17:34:23 -0200
Message-ID: <f56d2b75-cd10-c1ca-0f2f-49c6786b2bd0@linux.vnet.ibm.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <20170215063454.GA15020@lst.de>
 <9e2ca83a-d355-64f5-5d82-031761134c57@wdc.com>
 <20170215070609.GB10603@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38639 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932694AbdBPTeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 14:34:31 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1GJXtlB061317
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 14:34:30 -0500
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28ndphw688-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 14:34:30 -0500
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Thu, 16 Feb 2017 17:34:27 -0200
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id C3B161DC0072
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 14:34:26 -0500 (EST)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1GJYPDK37748816
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 17:34:25 -0200
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1GJYOoR023944
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 17:34:24 -0200
In-Reply-To: <20170215070609.GB10603@ram.oc3035372033.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ram Pai <linuxram@us.ibm.com>, Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>

On 15/02/2017 05:06, Ram Pai wrote:
> On Wed, Feb 15, 2017 at 03:48:52PM +0900, Damien Le Moal wrote:
>> Christoph,
>>
>> On 2/15/17 15:34, Christoph Hellwig wrote:
>>> this looks reasonable, but we should ask Guilherme and Ram to confirm
>>> it fixes their originally reported issue.  I've added them to Cc.
>>
>> Thank you.
>>
>> Guilherme, Ram,
>>
>> Please test ! The original fix breaks the zoned block device support
>> that was newly added to 4.10. So we need a fix for that and your issue
>> combined before Linus releases 4.10 stable this weekend.
> 
> Yes logically it looks correct and should fix our issue. 
> 
> I doubt Guilherme has access to the same adapter firmware that exposed
> the original problem. We will probably have to induce the erroneous
> behavior in the driver to reproduce the issue and verify the fix.

Ram, I do have access but the environment changed a lot, including
disks, setup of the distributed filesystem and tests...and so I wasn't
able to reproduce the issue anymore.

Since the logic of the new approach looks correct, I'm ok with the patch.

Thanks,


Guilherme

> 
> Will let you know,
> RP
> 
