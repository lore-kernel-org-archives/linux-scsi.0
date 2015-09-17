From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 1/4] scsi: remove old-style type names from sg.h
Date: Thu, 17 Sep 2015 08:24:09 -0700
Message-ID: <55FADB19.6010003@sandisk.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
 <1442497338-17019-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0095.outbound.protection.outlook.com ([157.56.111.95]:58648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752451AbbIQP11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 11:27:27 -0400
In-Reply-To: <1442497338-17019-2-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/17/2015 06:42 AM, Paolo Bonzini wrote:
> These will not be exported by the new linux/sg.h header, and scsi/sg.h will
> not have any user API after linux/sg.h is created.  Since they have no
> user in the kernel, they can be zapped.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
