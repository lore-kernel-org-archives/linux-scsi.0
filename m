From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/9] qla4xxx: Patches for scsi-misc
Date: Tue, 06 Dec 2011 14:15:44 -0600
Message-ID: <4EDE77F0.8050708@cs.wisc.edu>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39728 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1LFUPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 15:15:54 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com

On 12/02/2011 12:42 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> These patches are on top of patchset posted by Mike Christie:-
> http://marc.info/?l=linux-scsi&m=132279682021696&w=2
> 
> Mike Hernandez (1):
>       qla4xxx: Fix CPU lockups when ql4xdontresethba set
> 
> Nilesh Javali (1):
>       qla4xxx: Fix the IDC locking mechanism
> 
> Sarang Radke (2):
>       qla4xxx: fix call trace on rmmod with ql4xdontresethba=1
>       qla4xxx: Don't recover adapter if device state is FAILED
> 
> Shyam Sunder (1):
>       qla4xxx: check for FW alive before calling chip_reset
> 
> Vikas Chaudhary (4):
>       qla4xxx: Perform context resets in case of context failures.
>       qla4xxx: Wait for disable_acb before doing set_acb
>       qla4xxx: Fix qla4xxx_dump_buffer to dump buffer correctly
>       qla4xxx: Update driver version to 5.02.00-k10
> 

With the updated 3rd patch "[PATCH v2 3/9] qla4xxx: fix call trace on
rmmod with ql4xdontresethba=1" it looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
