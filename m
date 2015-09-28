From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 1/4] scsi: remove old-style type names from sg.h
Date: Mon, 28 Sep 2015 08:47:12 +0200
Message-ID: <5608E270.1080908@interlog.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-2-git-send-email-pbonzini@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40469 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbI1GrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 02:47:24 -0400
In-Reply-To: <1443173264-4105-2-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 15-09-25 11:27 AM, Paolo Bonzini wrote:
> These will not be exported by the new linux/sg.h header, and scsi/sg.h will
> not have any user API after linux/sg.h is created.  Since they have no
> user in the kernel, they can be zapped.
>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

