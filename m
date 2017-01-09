From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH 3/4] cxlflash: Cleanup prints
Date: Mon, 9 Jan 2017 17:50:19 +1100
Message-ID: <eda1310f-94b2-1c34-5dd4-cbb4ba21be43@au1.ibm.com>
References: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1483711518-18302-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758057AbdAIGu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 01:50:28 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v096mVUq142347
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2017 01:50:27 -0500
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27utp64htu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2017 01:50:27 -0500
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
        Mon, 9 Jan 2017 16:50:24 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
        by d23dlp02.au.ibm.com (Postfix) with ESMTP id 1EF412BB0055
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2017 17:50:21 +1100 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v096oKiR4391422
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2017 17:50:20 +1100
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v096oKRr023032
        for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2017 17:50:20 +1100
In-Reply-To: <1483711518-18302-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 07/01/17 01:05, Uma Krishnan wrote:
> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> The usage of prints within the cxlflash driver is inconsistent. This
> hinders debug and makes the driver source and log output appear sloppy.
>
> The following cleanups help unify the prints within cxlflash:
>  - move all prints to dev-* where possible
>  - transition all hex prints to lowercase
>  - standardize variable prints in debug output
>  - derive pointers in a consistent manner
>  - remove superfluous data from prints and print statements that do not
>    make sense

And change a couple of ints to bools, which isn't strictly print-related. :)

>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

An impressive cleanup! Nothing bad which stands out to me.

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>


-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

