From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Sat, 23 Mar 2013 01:21:13 -0500
Message-ID: <514D49D9.2000301@cs.wisc.edu>
References: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60714 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab3CWGVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Mar 2013 02:21:25 -0400
In-Reply-To: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 03/22/2013 06:08 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest
> convenience.
> 
> Nilesh Javali (1):
>       qla4xxx: Skip retry of initialize_adapter only for ISP8XXX
> 
> Vikas Chaudhary (3):
>       qla4xxx: Added missing check for ISP83XX in CHAP related functions
>       qla4xxx: Assign correct CHAP table address to FLT
>       qla4xxx: Update driver version to 5.03.00-k6
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

