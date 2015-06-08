From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 08 Jun 2015 16:41:06 -0500
Message-ID: <55760BF2.4010408@linux.vnet.ibm.com>
References: <1433540782-15276-1-git-send-email-mrochs@linux.vnet.ibm.com> <5575D6C6.5080808@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:32958 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbFHVlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2015 17:41:10 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Mon, 8 Jun 2015 15:41:09 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 016F23E40041
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2015 15:41:07 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t58LeVBl27066490
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 14:40:31 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t58Lf5wZ028648
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2015 15:41:06 -0600
In-Reply-To: <5575D6C6.5080808@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com

On 6/8/2015 12:54 PM, Brian King wrote:

>> +
>> +	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
>> +	if (unlikely(rcr))
>> +		rc = FAILED;
>
> Do you need to wait for all commands to the LUN to be returned before returning from
> here? You could put a simple loop here, polling until there are no ops outstanding
> to this LUN, if needed...

Brian:

Good suggestion. Would it be acceptable to add this capability in a 
future patch?

- Manoj

