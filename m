Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DEFC3276D
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 00:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6B072085B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 00:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgACAWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 19:22:44 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:55542 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgACAWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 19:22:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1inAjd-0006T5-0m; Fri, 03 Jan 2020 00:22:37 +0000
Message-ID: <dc17d939c813b004e0a50af2813a1eef1fbf9574.camel@codethink.co.uk>
Subject: Re: [GIT PULL v3 00/27] block, scsi: final compat_ioctl cleanup
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-doc@vger.kernel.org,
        corbet@lwn.net, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date:   Fri, 03 Jan 2020 00:22:36 +0000
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-01-02 at 15:55 +0100, Arnd Bergmann wrote:
[...]
> Changes since v2:
> - Rebase to v5.5-rc4, which contains the earlier bugfixes
> - Fix sr_block_compat_ioctl() error handling bug found by
>   Ben Hutchings
[...]

Unfortunately that fix was squashed into "compat_ioctl: move
sys_compat_ioctl() to ioctl.c" whereas it belongs in "compat_ioctl:
scsi: move ioctl handling into drivers".

If you decide to rebase again, you can add my Reviewed-by to all
patches.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

