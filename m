From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ibmvfc: Delay NPIV login retry and add retries
Date: Wed, 03 Dec 2008 15:54:04 -0600
Message-ID: <4936FFFC.3020506@linux.vnet.ibm.com>
References: <200812031703.mB3H3cMT027696@d03av04.boulder.ibm.com> <1228325901.5551.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40025 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYLCVyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 16:54:51 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB3LsMlv004233
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 16:54:22 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB3Lsoox109288
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 16:54:50 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB3Msxl1026580
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 17:54:59 -0500
In-Reply-To: <1228325901.5551.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-12-03 at 11:02 -0600, Brian King wrote:
>> Adds a delay prior to retrying a failed NPIV login. This fixes
>> a scenario if the backing fibre channel adapter is getting reset
>> due to an EEH event, NPIV login will fail. Currently, ibmvfc
>> retries three times very quickly, resets the CRQ and tries one
>> more time. If the adapter is getting reset due to EEH, this isn't
>> enough time. This adds a delay prior to retrying a failed NPIV
>> login and also increments the number of retries.
> 
> Are these for 2.6.28 or 2.6.29?  The descriptions make them sound like
> 2.6.28 bug fixes.

They can go in 2.6.29. They are bug fixes, but they are not easily hit.
They apply on top of all the other ibmvfc patches queued for 2.6.29.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


