From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH] scsi: replace wrong device handler name for
 CLARiiON       arrays
Date: Mon, 10 Oct 2016 11:18:01 +0800
Message-ID: <1476069481.3468.0.camel@linux.vnet.ibm.com>
References: <20161007161957.6042-1-xose.vazquez@gmail.com>
         <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
         <1475968905.2892.11.camel@linux.vnet.ibm.com>
         <20161009151955.GB20037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33805 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751939AbcJJDSM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2016 23:18:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9A3DhIP130876
        for <linux-scsi@vger.kernel.org>; Sun, 9 Oct 2016 23:18:12 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25yvq0j8w8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Oct 2016 23:18:12 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sun, 9 Oct 2016 21:18:11 -0600
In-Reply-To: <20161009151955.GB20037@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Sun, 2016-10-09 at 17:19 +0200, Christoph Hellwig wrote:
> On Sun, Oct 09, 2016 at 07:21:45AM +0800, James Bottomley wrote:
> > Actually, should we replace?  Aren't there older arrays still
> > bearing
> > the clariion name, so we should have these entries in addition?
> 
> The changed string isn't the inquiry vendor string, but the DH driver
> name it is mapped to.  And the driver for the clariion arrays is 
> indeed emc, even if the inquity data shows DGC.

Ah, missed that, thanks!

Patch looks fine to me then.

James

