From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client
 Driver
Date: Wed, 11 Jun 2008 11:01:44 -0500
Message-ID: <484FF6E8.6060207@linux.vnet.ibm.com>
References: <200806102250.m5AMoZdK007621@d03av04.boulder.ibm.com> <200806111718.20087.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60773 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYFKQCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2008 12:02:50 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5BG4urQ012598
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 12:04:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BG2S2w1343678
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 12:02:28 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5BG26KJ027226
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 10:02:06 -0600
In-Reply-To: <200806111718.20087.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com

Rolf Eike Beer wrote:
>> +	vhost->trace = kzalloc(sizeof(struct ibmvfc_trace_entry) *
>> +			       IBMVFC_NUM_TRACE_ENTRIES, GFP_KERNEL);
> 
> Use kcalloc() here.

Done.

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


