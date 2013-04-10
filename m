From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 10 Apr 2013 10:47:17 -0500
Message-ID: <51658985.7010307@cs.wisc.edu>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37245 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab3DJPsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 11:48:15 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 04/05/2013 06:06 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
>  
> Please apply the following patches to the scsi tree at your earliest
> convenience.
> 
> Adheer Chandravanshi (3):
>       qla4xxx: Use correct flash ddb offset for ISP40XX
>       qla4xxx: Restrict logout from boot target session using session id
>       qla4xxx: Use correct value for max flash node entries
> 
> Vikas Chaudhary (2):
>       qla4xxx: Added print statements to display AENs
>       qla4xxx: Update driver version to 5.03.00-k8
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

I am ignoring the warning about the uninitialized ddb_size because it
looks bogus due to the pddb check.

