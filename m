From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9 controllers
Date: Thu, 08 Sep 2016 14:25:14 -0400
Message-ID: <1473359114.2781.38.camel@linux.vnet.ibm.com>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
         <146706367078.29152.14405582249219794335.stgit@brunhilda>
         <yq1a8ghoim3.fsf@sermon.lab.mkp.net>
         <4993A297653ECB4581FA5C3C31323D191639AC20@avsrvexchmbx1.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758858AbcIHSZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 14:25:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u88IMkaY073908
        for <linux-scsi@vger.kernel.org>; Thu, 8 Sep 2016 14:25:25 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25bc343unu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2016 14:25:25 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 8 Sep 2016 12:25:24 -0600
In-Reply-To: <4993A297653ECB4581FA5C3C31323D191639AE64@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2016-09-08 at 18:15 +0000, Don Brace wrote:
> > > -    { 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /*
> > > Adaptec PMC
> > > Series 9 */
> > > 
> > > How are people that load aacraid in their initrd going to boot
> > > after
> > > this?
> > > 
> > > --
> > > Martin K. Petersen      Oracle Linux Engineering
> > 
> > I updated smartpqi/Kconfig and added
> > Documentation/scsi/smartpqi.txt to
> > inform users of the
> > need to configure the smartpqi driver moving forward for aacraid
> > Series 9
> > controllers.
> > 
> > Hope this helps.

That's not going to be enough: this ID has been in the aacriad driver
since 2011.  That means anyone who finally gets hold of one of these
new cards but uses a distro that doesn't have the new smartpqi driver
will be attached via the aacraid one.

Given that the life times of enterprise distributions is two years and
you're releasing this smartpqi soon, the overlap is unavoidable.

James


