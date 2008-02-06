From: Chandru <chandru@in.ibm.com>
Subject: Re: diskdump fails on x3850 (x86_64)
Date: Wed, 06 Feb 2008 19:56:18 +0530
Message-ID: <47A9C38A.7050402@in.ibm.com>
References: <47A85B75.5010401@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:39632 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYBFO0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 09:26:21 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m16ERAB2025911
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 01:27:10 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m16EQJRV2691200
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 01:26:19 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m16EQLN6009579
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 01:26:21 +1100
In-Reply-To: <47A85B75.5010401@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ciju@linux.vnet.ibm.com, david_chaw@adaptec.com

We looked at the code and there seem to be atleast two functions that 
may be required in the driver to support diskdump, dump_poll and 
dump_sanity_check as part of Scsi_Host_Template structure.  Different 
drivers have their own way of implementing these routines in the driver 
code. Hence we wanted to ask if the current developers of adp94xx can 
provide implementation for these routines.  The driver version that we 
have seems to be adp94xx - '1.0.8-13'

Regards,
Chandru

Ciju Rajan K wrote:
> Hello folks,
>
> Diskdump on x3850 with adp94xx driver is not working (Redhat 
> Enterprise Linux 4.6). 'Service diskdump restart' fails. Is there any 
> plan to support it?
>
> Thanks
> Ciju

