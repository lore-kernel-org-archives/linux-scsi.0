From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] test-case
Date: Thu, 1 Feb 2018 18:18:54 -0200
Message-ID: <20c33ceb-6517-aa2a-1dab-0f403f0cd4f0@linux.vnet.ibm.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1517426684-23050-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1517439022.7325.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754703AbeBAUTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 15:19:06 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w11KIpPU012066
        for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2018 15:19:06 -0500
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fv9tmg09x-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 01 Feb 2018 15:19:04 -0500
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Thu, 1 Feb 2018 15:19:04 -0500
In-Reply-To: <1517439022.7325.9.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 01/31/2018 08:50 PM, Bart Van Assche wrote:
> I think it would be useful to have some variant of the above code in the kernel
> tree. Are you familiar with the fault injection framework (see also
> <linux/fault-inject.h> and Documentation/fault-injection/fault-injection.txt)?

No, not yet.  That's very interesting.

> Do you think that framework would be appropriate for controlling whether or not
> the above code gets executed?

Yes, apparently it might be done w/ fail attributes to control the
wait-loop in the shutdown/unload hook, whether to call scsi_done(),
and whether to fail an error handler so it escalates to the next.

I'd be happy to take a look at it, if you/others are interested.
(just to make sure it does not end up rejected later because of
others' opinion. :-)

cheers,
Mauricio
