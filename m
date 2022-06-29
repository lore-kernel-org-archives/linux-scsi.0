Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AF1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 12:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiF2MRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 08:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiF2MQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 08:16:32 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36C035244;
        Wed, 29 Jun 2022 05:16:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LY0n24Wfcz4xZG;
        Wed, 29 Jun 2022 22:16:22 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <3b1dfb19a2c3265fb4abc2bfc7b6eae9261a998b.1654966508.git.christophe.leroy@csgroup.eu>
References: <3b1dfb19a2c3265fb4abc2bfc7b6eae9261a998b.1654966508.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH 1/2] powerpc: Don't include asm/setup.h in asm/machdep.h
Message-Id: <165650492297.3004956.3199700587499347269.b4-ty@ellerman.id.au>
Date:   Wed, 29 Jun 2022 22:15:22 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 11 Jun 2022 18:55:15 +0200, Christophe Leroy wrote:
> asm/machdep.h doesn't need asm/setup.h
> 
> Remove it.
> 
> Add it directly in files that needs it.
> 
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc: Don't include asm/setup.h in asm/machdep.h
      https://git.kernel.org/powerpc/c/113fe88eed53af08800f54a03e463636105831e0
[2/2] powerpc: Move prom_init() out of asm-prototypes.h
      https://git.kernel.org/powerpc/c/7dc3ba0a071892ea212f90f63738fd9f81b1f638

cheers
