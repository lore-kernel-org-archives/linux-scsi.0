Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6A7C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 13:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 635196190A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 13:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhC3NLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 09:11:41 -0400
Received: from elvis.franken.de ([193.175.24.41]:37693 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhC3NLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 09:11:38 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lRE9U-000488-00; Tue, 30 Mar 2021 15:11:24 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 405B2C1DF5; Tue, 30 Mar 2021 15:07:40 +0200 (CEST)
Date:   Tue, 30 Mar 2021 15:07:40 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Wang Qing <wangqing@vivo.com>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/6] mips/sgi-ip27: Delete obsolete TODO file
Message-ID: <20210330130740.GA11217@alpha.franken.de>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
 <1617087773-7183-2-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617087773-7183-2-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 03:02:44PM +0800, Wang Qing wrote:
> The TODO file here has not been updated for 15 years, and the function 
> development described in the file have been implemented or abandoned.
> 
> Its existence will mislead developers seeking to view outdated information.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  arch/mips/sgi-ip27/TODO | 19 -------------------
>  1 file changed, 19 deletions(-)
>  delete mode 100644 arch/mips/sgi-ip27/TODO

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
