From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: ufs: use MASK_EE_STATUS
Date: Mon, 24 Apr 2017 18:34:28 -0400
Message-ID: <yq18tmph1u3.fsf@oracle.com>
References: <20170420120145.7035-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22046 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939160AbdDXWel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:34:41 -0400
In-Reply-To: <20170420120145.7035-1-tkusumi@tuxera.com> (kusumi tomohiro's
        message of "Thu, 20 Apr 2017 15:01:44 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: subhashj@codeaurora.org, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>


> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>
> MASK_EE_STATUS added by 66ec6d59 was unused, but it seems to have been
> defined to do this.
>
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>

Subhash: Please review these two. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
