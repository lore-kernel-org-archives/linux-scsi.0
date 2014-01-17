From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/24] qla4xxx: 5.04.00-k4: Updates for scsi "misc" branch
Date: Fri, 17 Jan 2014 12:20:58 -0600
Message-ID: <52D9748A.6070501@cs.wisc.edu>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48555 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaAQSVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 13:21:09 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 12/16/2013 05:49 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest convenience.
> These patches are on top of other qla4xxx patch posted on list here:
> http://marc.info/?l=linux-scsi&m=138511809612830&w=2
> 
> Nilesh Javali (5):
>       qla4xxx: ISP8xxx: Correct retry of adapter initialization
>       qla4xxx: Improve loopback failure messages
>       qla4xxx: Rename ACB_STATE macros with IP_ADDRSTATE macros
>       qla4xxx: Clear DDB index map upon connection close failure
>       qla4xxx: Handle IPv6 AEN notifications
> 
> Tej Parkash (4):
>       qla4xxx: Fixed AER reset sequence for ISP83xx/ISP84xx
>       qla4xxx: Fix processing response queue during probe
>       qla4xxx: Fix pending IO completion in reset path before initiating chip reset
>       qla4xxx: Driver not able to collect minidump for ISP84xx
> 
> Vikas Chaudhary (15):
>       qla4xxx: Print WARN_ONCE() if iSCSI function presence bit removed
>       qla4xxx: Fix comments in code
>       qla4xxx: Use IDC_CTRL bit1 directly instead of AF_83XX_NO_FWDUMP flag.
>       qla4xxx: Correctly handle msleep_interruptible
>       qla4xxx: Return correct error status from func qla4xxx_request_irqs()
>       qla4xxx: Fix failure of IDC Time Extend mailbox command
>       qla4xxx: Reduce rom-lock contention during reset recovery.
>       qla4xxx: Fix failure of mbox 0x31
>       qla4xxx: Remove unused code from qla4xxx_set_ifcb()
>       qla4xxx: Updated print for device login, logout path
>       qla4xxx: Update print statements in qla4xxx_mailbox_command()
>       qla4xxx: Update print statements in func qla4xxx_eh_abort()
>       qla4xxx: Update print statements in func qla4xxx_do_dpc()
>       qla4xxx: Fix sparse warnings
>       qla4xxx: Update driver version to 5.04.00-k4
> 
> Thanks,
> Vikas.
> 

Patchset looks ok with fixed up [PATCH 16/24] patch here

"[PATCH V1 16/24] qla4xxx: Fix failure of mbox 0x31"
http://marc.info/?l=linux-scsi&m=138995390232212&w=2


Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
