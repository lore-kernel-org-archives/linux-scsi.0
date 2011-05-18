From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/10] qla4xxx: Updates for scsi-misc-2.6
Date: Wed, 18 May 2011 13:45:12 -0500
Message-ID: <4DD413B8.8010402@cs.wisc.edu>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50234 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386Ab1ERSoq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 14:44:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 05/18/2011 01:17 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> James,
>
> Please apply these patches on scsi-misc-2.6 tree.
>
> Harish Zunjarrao (1):
> 	qla4xxx: Added vendor specific sysfs attributes
>
> Lalit Chandivade (1):
> 	qla4xxx: Remove AF_DPC_SCHEDULED flag from ha.
>
> Prasanna Mumbai (2):
> 	qla4xxx: update function qla4xxx_isr_decode_mailbox()
> 	qla4xxx: Complete the cmd if sense_len is zero
>
> Vikas Chaudhary (6):
> 	qla4xxx: Updated the reset sequence for ISP82xx
> 	qla4xxx: Dump HW/FW reg to figure out what caused FW to be hung for ISP82XX
> 	qla4xxx: Don't process mbx interrupt unconditionally
> 	qla4xxx: Don't check FW alive if ISP82XX reset is in progress
> 	qla4xxx: Remove host_lock in queuecommand function
> 	qla4xxx: Update driver version to 5.02.00-k7
>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
