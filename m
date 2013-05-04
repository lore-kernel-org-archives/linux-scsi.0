From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Sat, 04 May 2013 19:02:48 +0200
Message-ID: <51853F38.9040805@acm.org>
References: <1366870200-6492-1-git-send-email-hare@suse.de>  <20130503102400.Horde.TQF1IJir309Rg8iARNPkSKA@imap.linux.ibm.com> <1367605401.5981.45.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:40915 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761663Ab3EDRCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 May 2013 13:02:52 -0400
In-Reply-To: <1367605401.5981.45.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

On 05/03/13 20:23, James Bottomley wrote:
> +	const unsigned long stall_for = min(msecs_to_jiffies(10), 1UL);

Hello James,

Can you please clarify what the intention of this statement is ? Is the 
purpose of this statement to avoid that stall_for would be zero in case 
HZ < 100 ? If that is the case, maybe you meant max() instead of min() ? 
Also, are you aware that msecs_to_jiffies() already rounds up the result 
of the division ?

Bart.

