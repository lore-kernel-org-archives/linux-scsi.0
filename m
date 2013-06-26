From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 26 Jun 2013 10:37:07 -0500
Message-ID: <51CB0AA3.2030805@cs.wisc.edu>
References: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33074 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3FZPhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 11:37:18 -0400
In-Reply-To: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 06/26/2013 07:11 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Following patches are to display additional iSCSI connection and session
> parameters in sysfs.
> 
> Please apply these patches to the scsi tree "misc" branch at your
> earliest convenience.
> 
> Adheer Chandravanshi (3):
>       scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs
>       libiscsi: Exporting new attrs for iscsi session and connection in sysfs
>       qla4xxx: Exporting new attrs for iscsi session and connection in sysfs
> 
> Vikas Chaudhary (1):
>       qla4xxx: Update driver version to 5.03.00-k10
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

