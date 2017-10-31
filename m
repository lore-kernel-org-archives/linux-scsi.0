From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 12:35:12 -0400
Message-ID: <yq1vaiv9sxr.fsf@oracle.com>
References: <20171025100526.GA144967@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42578 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbdJaQfW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 12:35:22 -0400
In-Reply-To: <20171025100526.GA144967@beast> (Kees Cook's message of "Wed, 25
        Oct 2017 03:05:26 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Kees,

> stat_timer only ever assigns the same function and data, so
> consolidate to using timer_setup(), adjust callback, drop everything
> else used to pass things around, and remove needless typedefs.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
