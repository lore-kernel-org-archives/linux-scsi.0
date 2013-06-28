From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH V1 1/4] scsi_transport_iscsi: Exporting new attrs for
 iscsi session and connection in sysfs
Date: Fri, 28 Jun 2013 19:54:02 +0000
Message-ID: <1372449241.1884.17.camel@dabdike>
References: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
	 <1372248694-3928-2-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:40336 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3F1TyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 15:54:06 -0400
In-Reply-To: <1372248694-3928-2-git-send-email-vikas.chaudhary@qlogic.com>
Content-Language: en-US
Content-ID: <260DC7CEBAF8F541840E755F52E98A68@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lalit.chandivade@qlogic.com" <lalit.chandivade@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

On Wed, 2013-06-26 at 08:11 -0400, vikas.chaudhary@qlogic.com wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> 
> Exporting new iSCSI Session and Connection parameters to sysfs

This doesn't apply:

patching file drivers/scsi/scsi_transport_iscsi.c
Hunk #5 FAILED at 3537.
Hunk #6 succeeded at 3644 (offset 6 lines).
Hunk #7 FAILED at 3709.
2 out of 7 hunks FAILED -- saving rejects to file
drivers/scsi/scsi_transport_iscsi.c.rej
patching file include/scsi/iscsi_if.h
Hunk #1 FAILED at 489.
1 out of 1 hunk FAILED -- saving rejects to file
include/scsi/iscsi_if.h.rej

It looks like it needs regenerating against scsi-misc, please (I think
it's conflicting with the ibft boot session sysfs entries).

Thanks,

James

