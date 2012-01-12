From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/7] qla4xxx: Update driver version to 5.02.00-k12
Date: Wed, 11 Jan 2012 20:02:00 -0600
Message-ID: <4F0E3F18.90608@cs.wisc.edu>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48240 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2ALByE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2012 20:54:04 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 01/11/2012 04:44 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Giridhar Malavali (1):
>       qla4xxx: Disable generating pause frames in case of FW hung
> 
> Karen Higgins (1):
>       qla4xxx: Cleanup modinfo display
> 
> Mike Hernandez (1):
>       qla4xxx: Temperature monitoring for ISP82XX core.
> 
> Nilesh Javali (1):
>       qla4xxx: Added error logging for firmware abort
> 
> Sarang Radke (1):
>       qla4xxx: Clear the RISC interrupt bit during FW init
> 
> Vikas Chaudhary (2):
>       qla4xxx: Update license
>       qla4xxx: Update driver version to 5.02.00-k12
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
