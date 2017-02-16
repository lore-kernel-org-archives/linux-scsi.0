From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/16] aacraid: Added sysfs for driver version
Date: Thu, 16 Feb 2017 08:43:19 +0100
Message-ID: <d51bf566-59c3-1f7a-1998-01f17cb33e85@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-7-RaghavaAditya.Renukunta@microsemi.com>
 <30a69431-f904-38f7-7aca-df2ff02cc5d0@suse.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C180D@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752071AbdBPHnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 02:43:21 -0500
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8C180D@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>

On 02/15/2017 07:12 PM, Raghava Aditya Renukunta wrote:
> 
> I agree , but it makes it easier to get the driver version when I am developing
> and I don't know which driver version is currently loaded
> 
> In addition internally our test automation suites use this information as
> opposed to modinfo to get the driver version running. 

OK then.

Speaking of test automation, is there something you may be able to share?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
