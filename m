From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/3] qla4xxx: Update for scsi-misc
Date: Tue, 06 Mar 2012 14:10:35 -0600
Message-ID: <4F566F3B.9000500@cs.wisc.edu>
References: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45440 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030848Ab2CFUKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2012 15:10:46 -0500
In-Reply-To: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 03/06/2012 06:16 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Vikas Chaudhary (3):
>       iscsi_transport: Added error status code for ping comp event
>       qla4xxx: Removed packed attr from struct iscsi_chap_rec
>       qla4xxx: Update driver version to 5.02.00-k16
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

