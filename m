Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D38CC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9726023E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhHRAYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 20:24:43 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.209]:44138 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234302AbhHRAYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 20:24:42 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2021 20:24:42 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id C23EEE8CE
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 19:03:45 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id G93ZmpnwKMGeEG93Zmq9d9; Tue, 17 Aug 2021 19:03:45 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iQ7/KUtVSBl2ZF7aCwEPA/oEGhWJX+G5Tor9oPp//b0=; b=GwgyHLFKKMQck5mJqwxNWY4vTU
        8A56XSwt+v7gd9lwTqN52riXiYtedRislJly+VXRTZMYvA+onvCiZSqcBqMeF5KE7ZMwGYWtNIpBf
        I07jy0bXlnOdQAvYjLyFSpg+SyU3JTsvjBT/4e36pu38VhuUbADV9cTN2Bp5qrR8liRgvXx4uc1L6
        VhYUBp0anm0FLW6Wk6JD0wruvctUCBniH1FeDiE8XTnUS4F7oZx5D1IX67Ryt7VXrMQKc+b2qoFVq
        wWStR6lomgHCrYWoKQf3qf95+agwxENEsp0C+zqPoXRFfPhuGmuoeqEi0qEb3dfe9ypQ3jbiTJzGd
        6FL2M9aw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:44728 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mG93Z-002CVZ-7Y; Tue, 17 Aug 2021 19:03:45 -0500
Subject: Re: [PATCH] scsi: st: Add missing break in switch statement in
 st_ioctl()
To:     Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210817235531.172995-1-nathan@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <5c2dd751-ba1d-efc1-54b8-2aa9968990c1@embeddedor.com>
Date:   Tue, 17 Aug 2021 19:06:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210817235531.172995-1-nathan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mG93Z-002CVZ-7Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:44728
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/17/21 18:55, Nathan Chancellor wrote:
> Clang + -Wimplicit-fallthrough warns:
> 
> drivers/scsi/st.c:3831:2: warning: unannotated fall-through between
> switch labels [-Wimplicit-fallthrough]
>         default:
>         ^
> drivers/scsi/st.c:3831:2: note: insert 'break;' to avoid fall-through
>         default:
>         ^
>         break;
> 1 warning generated.
> 
> Clang's -Wimplicit-fallthrough is a little bit more pedantic than GCC's,
> requiring every case block to end in break, return, or fallthrough,
> rather than allowing implicit fallthroughs to cases that just contain
> break or return. Add a break so that there is no more warning, as has
> been done all over the tree already.
> 
> Fixes: 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()")

I don't think this tag is needed for these patches.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I also got the warnings in staging and ntfs3, I have the fixes for those in my
local tree and I will commit them to my tree, soon.

Thanks
--
Gustavo

> ---
>  drivers/scsi/st.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 2d1b0594af69..0e36a36ed24d 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>  	case CDROM_SEND_PACKET:
>  		if (!capable(CAP_SYS_RAWIO))
>  			return -EPERM;
> +		break;
>  	default:
>  		break;
>  	}
> 
> base-commit: 58dd8f6e1cf8c47e81fbec9f47099772ab75278b
> 
