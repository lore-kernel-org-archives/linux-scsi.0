From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/10] qla4xxx: 5.04.00-k5: Updates for scsi "misc" branch
Date: Thu, 08 May 2014 16:27:04 -0500
Message-ID: <536BF6A8.1090404@cs.wisc.edu>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39471 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbaEHV1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2014 17:27:17 -0400
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 02/24/2014 09:06 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest convenience.
> 
> Tej Parkash (5):
>       qla4xxx: Do not wait for IO completion, after issuing stop_firmware
>       qla4xxx: Change default capture to firmware defined capture mask
>       qla4xxx: Add support of 0xFF capture mask for minidump
>       qla4xxx: Added new opcodes for 84XX Minidump template
>       qla4xxx: Added PEX DMA Support for ISP8022 Adapter
> 
> Vikas Chaudhary (5):
>       qla4xxx: qla4xxx: Move qla4_8xxx_ms_mem_write_128b to ql4_nx.c
>       qla4xxx: Check for correct return status
>       qla4xxx: Initialize hardware queue for ISP40XX
>       qla4xxx: Fix memory leak in func qla4_84xx_config_acb()
>       qla4xxx: Update driver version to 5.04.00-k5
> 

I guess my concerns about a mem leak are fixed in the patchset sent on
4/9 "qla4xxx: 5.04.00-k6: Updates for scsi "misc" branch". I thought the
name of some define in this set was silly, but I guess it is fine and
will be changed later. So patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

