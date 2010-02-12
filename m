From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Thu, 11 Feb 2010 18:06:21 -0600
Message-ID: <4B749B7D.3010607@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu> <20100211110852.GB8237@linux-qf4p> <4B748B4D.5030809@cs.wisc.edu> <4B748C86.6030903@cs.wisc.edu> <0CB616B0-0903-41A0-9ADD-5DD64989FFD1@qlogic.com> <4B7498A5.4040307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53534 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0BLAGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 19:06:38 -0500
In-Reply-To: <4B7498A5.4040307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ravi.anand" <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/11/2010 05:54 PM, Mike Christie wrote:
> spin_lock_irqsave(&ha->hardware_lock, flags);
>

The lock should not be held while we sleep of course :)

> qla4xxx_eh_wait_on_command(ha, cmd);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

