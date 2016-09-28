From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCHv2] MAINTAINERS: Update open-iscsi maintainers
Date: Tue, 27 Sep 2016 22:05:26 -0500
Message-ID: <57EB3376.4040802@redhat.com>
References: <1474928730-4947-1-git-send-email-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756059AbcI1DF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 23:05:28 -0400
In-Reply-To: <1474928730-4947-1-git-send-email-lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, Chris Leech <cleech@redhat.com>, Mike Christie <mnc@redhat.com>

On 09/26/2016 05:25 PM, Lee Duncan wrote:
> Chris Leech and I are taking over as open-iscsi maintainers.
> 
> Changes since v1:
>  * Updated URL to open-iscsi.com
>  * Removed git repository, since code in tree
> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 01bff8ea28d8..81384a2562e7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6448,10 +6448,10 @@ S:	Maintained
>  F:	drivers/firmware/iscsi_ibft*
>  
>  ISCSI
> -M:	Mike Christie <michaelc@cs.wisc.edu>
> +M:	Lee Duncan <lduncan@suse.com>
> +M:	Chris Leech <cleech@redhat.com>
>  L:	open-iscsi@googlegroups.com
> -W:	www.open-iscsi.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
> +W:	www.open-iscsi.com
>  S:	Maintained
>  F:	drivers/scsi/*iscsi*
>  F:	include/scsi/*iscsi*
> 

After over 10 years, I will get to take a vacation where I do not have
to think about iSCSI :)

Reviewed-by: Mike Christie <mchristi@redhat.com>
