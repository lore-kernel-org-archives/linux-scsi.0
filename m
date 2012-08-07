From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch.
Date: Tue, 07 Aug 2012 11:52:25 -0500
Message-ID: <502147C9.3000401@cs.wisc.edu>
References: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44023 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2HGQwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2012 12:52:34 -0400
In-Reply-To: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 08/07/2012 06:57 AM, vikas.chaudhary@qlogic.com wrote:
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
> Lalit Chandivade (1):
>       qla4xxx: Properly handle SCSI underrun while processing status IOCBs.
> 
> Manish Rangankar (2):
>       qla4xxx: Fix memory corruption issue in qla4xxx_ep_connect.
>       qla4xxx: Fix multiple conn login event issue during session recovery.
> 
> Vikas Chaudhary (2):
>       qla4xxx: Fix gcc warning for x86 system
>       qla4xxx: Update driver version to 5.02.00-k19
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
