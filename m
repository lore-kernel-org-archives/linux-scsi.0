From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch.
Date: Thu, 14 Jun 2012 23:32:37 -0500
Message-ID: <4FDABAE5.6000307@cs.wisc.edu>
References: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36528 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2FOEcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 00:32:19 -0400
In-Reply-To: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 06/14/2012 05:35 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest
> convenience for inclusion in mainline.
> 
> Vikas Chaudhary (4):
>       qla4xxx: multi-session fix for flash ddbs
>       qla4xxx: Fix a Sparse warning message
>       qla4xxx: Fix Spell check.
>       qla4xxx: Update driver version to 5.02.00-k18
> 
>  drivers/scsi/qla4xxx/ql4_def.h     |    1 +
>  drivers/scsi/qla4xxx/ql4_glbl.h    |    3 +-
>  drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
>  drivers/scsi/qla4xxx/ql4_os.c      |  156 +++++++++++++++++++++++++++++++++---
>  drivers/scsi/qla4xxx/ql4_version.h |    2 +-
> 
> Thanks,
> Vikas.


Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
