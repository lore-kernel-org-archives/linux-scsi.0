From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Tue, 14 Feb 2017 23:06:09 -0800
Message-ID: <20170215070609.GB10603@ram.oc3035372033.ibm.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <20170215063454.GA15020@lst.de>
 <9e2ca83a-d355-64f5-5d82-031761134c57@wdc.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750810AbdBOHGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 02:06:24 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1F74FIM138368
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2017 02:06:23 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28mcwhst15-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2017 02:06:23 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <linuxram@us.ibm.com>;
        Wed, 15 Feb 2017 00:06:21 -0700
Content-Disposition: inline
In-Reply-To: <9e2ca83a-d355-64f5-5d82-031761134c57@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>

On Wed, Feb 15, 2017 at 03:48:52PM +0900, Damien Le Moal wrote:
> Christoph,
> 
> On 2/15/17 15:34, Christoph Hellwig wrote:
> > this looks reasonable, but we should ask Guilherme and Ram to confirm
> > it fixes their originally reported issue.  I've added them to Cc.
> 
> Thank you.
> 
> Guilherme, Ram,
> 
> Please test ! The original fix breaks the zoned block device support
> that was newly added to 4.10. So we need a fix for that and your issue
> combined before Linus releases 4.10 stable this weekend.

Yes logically it looks correct and should fix our issue. 

I doubt Guilherme has access to the same adapter firmware that exposed
the original problem. We will probably have to induce the erroneous
behavior in the driver to reproduce the issue and verify the fix.

Will let you know,
RP
