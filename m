From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csiostor: Avoid content leaks and casts
Date: Tue, 23 May 2017 21:46:22 -0400
Message-ID: <yq1efvfxc0h.fsf@oracle.com>
References: <20170509223444.GA51314@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31675 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759177AbdEXBqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 21:46:31 -0400
In-Reply-To: <20170509223444.GA51314@beast> (Kees Cook's message of "Tue, 9
        May 2017 15:34:44 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>


Kees,

> When copying attributes, the len argument was padded out and the
> resulting memcpy() would copy beyond the end of the source buffer.
> Avoid this, and use size_t for val_len to avoid all the
> casts. Similarly, avoid source buffer casts and use void *.
>
> Additionally enforces val_len can be represented by u16 and that the
> DMA buffer was not overflowed. Fixes the size of mfa, which is not
> FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN (but it will be padded up to
> 4). This was noticed by the future CONFIG_FORTIFY_SOURCE checks.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
