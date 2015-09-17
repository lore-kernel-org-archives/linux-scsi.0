From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 2/4] scsi: cleanup scsi/scsi_ioctl.h
Date: Thu, 17 Sep 2015 08:27:55 -0700
Message-ID: <55FADBFB.3060303@sandisk.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
 <1442497338-17019-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:20544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752054AbbIQP2B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 11:28:01 -0400
In-Reply-To: <1442497338-17019-3-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/17/2015 06:42 AM, Paolo Bonzini wrote:
> SCSI_REMOVAL_* goes together with other SCSI command constants in
> include/scsi/scsi.h.  It is also used outside the implementation
> of the ioctls (and it is not part of the user API).
>
> scsi_fctargaddress/Scsi_FCTargAddress has had no in-tree use since
> commit ca61f10ab2b8 ("[SCSI] remove broken driver cpqfc", 2005-10-29).
> Remove it, just in time for the the tenth anniversary of its demise.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

