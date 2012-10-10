From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 10 Oct 2012 11:08:56 -0500
Message-ID: <2C4E81FE-8AE8-4E48-A87C-536A40E0CCBA@cs.wisc.edu>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45521 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2JJQJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 12:09:52 -0400
In-Reply-To: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com


On Oct 10, 2012, at 6:24 AM, vikas.chaudhary@qlogic.com wrote:

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

I think some of these should be common operations instead of vendor ones.


> Adheer Chandravanshi (1):
>      qla4xxx: Added new BSG command QLISCSI_VND_ABOUT_FIRMWARE
> 

What info does this provide?


> Harish Zunjarrao (3):
>      qla4xxx: Allow reset in link down case
>      qla4xxx: Invoke Set Address Control Block using BSG

Does this set the networking info?


>      qla4xxx: Invoke DisableACB using BSG

What does this do? Disable the networking?



> Manish Rangankar (2):
>      qla4xxx: Add get default DDB support using BSG.

What does this do? Get the default DDB settings?

>      qla4xxx: Add get DDB support using BSG.



