From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 00/14] qla4xxx: Patches for scsi-misc
Date: Sat, 08 Oct 2011 00:52:13 -0500
Message-ID: <4E8FE50D.6000603@cs.wisc.edu>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50733 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1JHFwY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Oct 2011 01:52:24 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 10/07/2011 06:55 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> This patchset address all the comments posted here:
>  - http://www.spinics.net/lists/linux-scsi/msg54819.html
>  - http://www.spinics.net/lists/linux-scsi/msg54813.html
>  - http://www.spinics.net/lists/linux-scsi/msg54815.html
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Lalit Chandivade (5):
>       qla4xxx: Fix bidirectional CHAP.
>       qla4xxx: Do not add duplicate CHAP entry in FLASH
>       qla4xxx: Fix exporting boot targets to sysfs
>       qla4xxx: Fix getting BIDI CHAP for boot targets
>       qla4xxx: Free Device Database (DDB) reserved by FW
> 
> Manish Rangankar (6):
>       qla4xxx: Clear DDB map index on the basis of AEN.
>       qla4xxx: Fixed session destroy issue on link up-down.
>       qla4xxx: Fixed device blocked issue on link up-down.
>       qla4xxx: Fixed active session re-open issue.
>       qla4xxx: Fixed target discovery failed issue.
>       qla4xxx: updated device id check for BFS.
> 
> Nilesh Javali (1):
>       qla4xxx: Add new FLT firmware region
> 
> Vikas Chaudhary (2):
>       qla4xxx: Update license
>       qla4xxx: Update driver version to 5.02.00-k8
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
