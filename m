From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csiostor: Avoid content leaks and casts
Date: Thu, 18 May 2017 21:35:27 -0400
Message-ID: <yq1pof54oio.fsf@oracle.com>
References: <20170509223444.GA51314@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170509223444.GA51314@beast> (Kees Cook's message of "Tue, 9
        May 2017 15:34:44 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Varun,

You weren't CC:ed on this patch. Please review. Thanks!

> When copying attributes, the len argument was padded out and the
> resulting memcpy() would copy beyond the end of the source buffer.
> Avoid this, and use size_t for val_len to avoid all the
> casts. Similarly, avoid source buffer casts and use void *.
>
> Additionally enforces val_len can be represented by u16 and that the
> DMA buffer was not overflowed. Fixes the size of mfa, which is not
> FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN (but it will be padded up to
> 4). This was noticed by the future CONFIG_FORTIFY_SOURCE checks.

https://patchwork.kernel.org/patch/9718995/

-- 
Martin K. Petersen	Oracle Linux Engineering
