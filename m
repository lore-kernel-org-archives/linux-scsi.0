Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC173C2BB40
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 11:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B535E23D57
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 11:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbgLJLbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389512AbgLJLaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 06:30:52 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 77BE5C0613CF;
        Thu, 10 Dec 2020 03:30:37 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CsBYJ2d3xz9shn; Thu, 10 Dec 2020 22:30:28 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Geoff Levand <geoff@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Takashi Iwai <tiwai@suse.com>,
        Uwe =?ISO-8859-1?Q?=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        alsa-devel@alsa-project.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] ALSA: ppc: drop if block with always false condition
Message-Id: <160756606231.1313423.17458520968397977116.b4-ty@ellerman.id.au>
Date:   Thu, 10 Dec 2020 22:30:28 +1100 (AEDT)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Nov 2020 17:59:49 +0100, Uwe Kleine-König wrote:
> The remove callback is only called for devices that were probed
> successfully before. As the matching probe function cannot complete
> without error if dev->match_id != PS3_MATCH_ID_SOUND, we don't have to
> check this here.

Applied to powerpc/next.

[1/2] ALSA: ppc: drop if block with always false condition
      https://git.kernel.org/powerpc/c/7ff94669e7d8e50756cd57947283381ae9665759
[2/2] powerpc/ps3: make system bus's remove and shutdown callbacks return void
      https://git.kernel.org/powerpc/c/6d247e4d264961aa3b871290f9b11a48d5a567f2

cheers
