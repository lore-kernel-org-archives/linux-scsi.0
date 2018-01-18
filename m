From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH-next] ibmvfc: Remove unneeded semicolons
Date: Thu, 18 Jan 2018 10:57:15 -0800
Message-ID: <4bf819be-8a5c-4486-2bef-60de4f5dd27d@linux.vnet.ibm.com>
References: <20180118013839.17792-1-chrisadr@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932089AbeARS5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 13:57:24 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0IIs9X7089989
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 13:57:23 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fjvgjxt9t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 13:57:23 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Thu, 18 Jan 2018 13:57:21 -0500
In-Reply-To: <20180118013839.17792-1-chrisadr@gentoo.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?Christopher_D=c3=adaz_Riveros?= <chrisadr@gentoo.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au
Cc: linux-scsi@vger.kernel.org

On 01/17/2018 05:38 PM, Christopher Díaz Riveros wrote:
> Trivial fix removes unneeded semicolons after switch blocks.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
> ---

Resending from the correct email address. :)

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
