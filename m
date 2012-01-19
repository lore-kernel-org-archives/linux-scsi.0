From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] qla4xxx: Patches for scsi-misc
Date: Thu, 19 Jan 2012 06:37:15 -0600
Message-ID: <4F180E7B.30402@cs.wisc.edu>
References: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32801 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab2ASMhZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 07:37:25 -0500
In-Reply-To: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 01/19/2012 05:06 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Vikas Chaudhary (5):
>       libiscsi: Added support to show targetalias in sysfs
>       qla4xxx: Added support to show targetalias in sysfs
>       scsi_transport_iscsi: Added support to show port_state and port_speed in sysfs
>       qla4xxx: Added support to show port_state and port_speed in sysfs
>       qla4xxx: Update driver version to 5.02.00-k13
> 

Looks ok to me

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
