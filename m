From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] RESEND Add support for new IBM SAS controllers
Date: Wed, 02 Jan 2013 15:05:26 -0500
Message-ID: <20130102150526.Horde.Tfad3Jir309Q5JMGzyx1ZBA@imap.linux.ibm.com>
References: <20130102182312.041361425@linux.vnet.ibm.com>
 <50E47EDF.8030009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53901 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab3ABUF4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2013 15:05:56 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 2 Jan 2013 15:05:55 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 599326E8048
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jan 2013 15:05:50 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r02K5oaO287370
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 15:05:51 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r02K5SoM001313
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 13:05:29 -0700
In-Reply-To: <50E47EDF.8030009@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Quoting Bart Van Assche <bvanassche@acm.org>:

> On 01/02/13 19:23, wenxiong@linux.vnet.ibm.com wrote:
>> I am re-sending "blk iopoll support" and "bump version" patches in  
>> previous series.
>
> Hello Wendy,
>
> How much do these patches improve the performance of the ipr driver ?
>
> Thanks,
>
> Bart.

Hi Bart,

we enable blk iopoll support in ipr driver when firmware supports  
multiple hrrq. With multiple hrrq support and cpu binding tuning, we  
can see 10%-20% performance improvement in some FIO cases.

Thanks,
Wendy

