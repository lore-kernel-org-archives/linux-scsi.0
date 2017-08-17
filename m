From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a
 request"
Date: Thu, 17 Aug 2017 12:40:41 -0500
Message-ID: <ff56b05f-0493-5d28-82d1-d9626b0e25c1@linux.vnet.ibm.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
 <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
 <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> <yq18tijow0o.fsf@oracle.com>
 <1502933351.14158.3.camel@wdc.com> <yq1a82znec9.fsf@oracle.com>
 <1502937699.2763.1.camel@wdc.com> <yq1tw16nbzf.fsf@oracle.com>
 <1502983764.2615.3.camel@wdc.com> <yq14lt6m9c0.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36629 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753361AbdHQRkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Aug 2017 13:40:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7HHcoHG144662
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2017 13:40:47 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cdeq0tv25-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2017 13:40:46 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 17 Aug 2017 13:40:46 -0400
In-Reply-To: <yq14lt6m9c0.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>

On 08/17/2017 11:45 AM, Martin K. Petersen wrote:
> 
> Bart,
> 
>> I think this means that the ipr fix went upstream before it ended up in
>> linux-next.
> 
> OK.
> 
> Brian: Please make sure you test with your ipr change in place as well
> as Bart's patch. And then report back.

They are separate issues. The ipr fix that is now upstream is for a
locking issue in ipr. The boot hang issue is a separate issue. I
can reproduce the boot hang on a system with my ipr patch. I've
confirmed it goes away when reverting Bart's patch but it makes
no sense as of yet as to why. 

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
