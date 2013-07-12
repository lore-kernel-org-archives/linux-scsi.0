From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 1/4] scsi_transport_iscsi: Exporting new attrs for
 iscsi session and connection in sysfs
Date: Fri, 12 Jul 2013 03:48:16 -0500
Message-ID: <51DFC2D0.7050405@cs.wisc.edu>
References: <1372672454-31817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55521 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab3GLIs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 04:48:27 -0400
In-Reply-To: <1372672454-31817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

The V2 of this patchset looks ok now. I did a quick compile test to
verify they apply and compile against the current scsi misc code that
has Eddie's changes in it.

James, sorry about the mismatch on the V1. I forgot Eddie's patches were
getting merged and would conflict with Vikas's patches in this set.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>



On 07/01/2013 04:54 AM, vikas.chaudhary@qlogic.com wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> 
> Exporting new iSCSI Session and Connection parameters to sysfs
> 
> Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---

