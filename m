From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Mon, 25 Sep 2017 18:09:08 -0300
Message-ID: <b15b69e2-0d41-56cd-2952-a214d7ad7973@linux.vnet.ibm.com>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
 <423FD6710FB8FB4F8728F93591889F9A5B8CD1FA@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752028AbdIYVJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 17:09:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8PL9ZAj104904
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 17:09:37 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d77dr61q9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 17:09:36 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Mon, 25 Sep 2017 17:09:15 -0400
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A5B8CD1FA@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "dougmill@linux.vnet.ibm.com" <dougmill@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, James.Bottomley@HansenPartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/21/2017 01:19 PM, Dave Carroll wrote:
>> [...]
>> ---
> Acked-by: Dave Carroll <david.carroll@microsemi.com>
> 

Thanks Dave!

James/Martin, am I expected to send a v2 with some change? Perhaps with
Dave's ack?
Sorry to annoy, thanks in advance for any advice!

Cheers,


Guilherme
