From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 3/4] scsi: move all obsolete ioctls to
 scsi/scsi_ioctl.h
Date: Thu, 17 Sep 2015 08:26:45 -0700
Message-ID: <55FADBB5.1020108@sandisk.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
 <1442497338-17019-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:56032
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751874AbbIQP0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 11:26:55 -0400
In-Reply-To: <1442497338-17019-4-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/17/2015 06:42 AM, Paolo Bonzini wrote:
> Some are in scsi/scsi.h.  Keep them together in preparation for exposing
> them in UAPI headers.
>
> Suggested-by: Christoph Hellwig<hch@lst.de>
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
