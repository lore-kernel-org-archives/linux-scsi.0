From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch.
Date: Thu, 06 Sep 2012 00:36:10 -0500
Message-ID: <5048364A.7030904@cs.wisc.edu>
References: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36762 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2IFFgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2012 01:36:31 -0400
In-Reply-To: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 08/22/2012 06:45 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest
> convenience.
> 
> Thanks,
> Vikas.
> 
> Vikas Chaudhary (4):
>       qla4xxx: Fix lockdep warning in qla4xxx_post_work()
>       qla4xxx: Clear interrupt while unloading driver.
>       qla4xxx: Wait for cmd to complete before chip reset for ISP40XX
>       qla4xxx: Update driver version to 5.02.00-k20
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

