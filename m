Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B51C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiGYUj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiGYUj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 16:39:26 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749922BF7
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 13:39:25 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id zYfN2700F4C55Sk01YfNAN; Mon, 25 Jul 2022 22:39:23 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oG4rK-005GYD-Hj; Mon, 25 Jul 2022 22:39:22 +0200
Date:   Mon, 25 Jul 2022 22:39:22 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Build regressions/improvements in v5.19-rc8
In-Reply-To: <20220725203417.3446690-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2207252237200.1255142@ramsan.of.borg>
References: <CAHk-=wiWwDYxNhnStS0e+p-NTFAQSHvab=2-8LwxunCVuY5-2A@mail.gmail.com> <20220725203417.3446690-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 Jul 2022, Geert Uytterhoeven wrote:
> JFYI, when comparing v5.19-rc8[1] to v5.19-rc7[3], the summaries are:
>  - build errors: +1/-5

   + /kisskb/src/include/ufs/ufshci.h: error: initializer element is not constant:  => 245:36

v5.19-rc8/powerpc-gcc5/ppc64_book3e_allmodconfig
v5.19-rc8/powerpc-gcc5/powerpc-allmodconfig
v5.19-rc8/powerpc-gcc5/ppc64le_allmodconfig

Seen before

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/e0dccc3b76fb35bb257b4118367a883073d7390e/ (all 135 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/ff6992735ade75aae3e35d16b17da1008d753d28/ (all 135 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
