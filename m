Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199C9CDB474
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Oct 2023 17:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjJVRHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Oct 2023 13:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjJVRGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Oct 2023 13:06:50 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720BF10FE
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 10:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1697994388;
        bh=95BWdYpieA1jfCJkLTVcMtXh8VjD0uWsXDor/VLum28=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=WhAKF1ptXoD72GDjWu2I1FTDZf0aTtXIFWCtaRVTBDP7HkrX0TNo5rMRWZuoCV/BJ
         BaLexMVi/+YlEhEFiKSczBmXMRBbUaU3io18uwFPJRpDKJbRI7MscLBr0oYAYbiK2m
         rAMyltdvI52z08nKTqCrJUR73Sxxyx27g7n+0zIQ=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id AE3D51285D91;
        Sun, 22 Oct 2023 13:06:28 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id GqSHSIh7KOph; Sun, 22 Oct 2023 13:06:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1697994388;
        bh=95BWdYpieA1jfCJkLTVcMtXh8VjD0uWsXDor/VLum28=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=WhAKF1ptXoD72GDjWu2I1FTDZf0aTtXIFWCtaRVTBDP7HkrX0TNo5rMRWZuoCV/BJ
         BaLexMVi/+YlEhEFiKSczBmXMRBbUaU3io18uwFPJRpDKJbRI7MscLBr0oYAYbiK2m
         rAMyltdvI52z08nKTqCrJUR73Sxxyx27g7n+0zIQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B70021280FB4;
        Sun, 22 Oct 2023 13:06:27 -0400 (EDT)
Message-ID: <b4ebea2eeb63aaa7ba0877cee0c9ca966af9eae0.camel@HansenPartnership.com>
Subject: Re: Oops with v6.6-rc6+
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Borislav Petkov <bp@alien8.de>, Julian Wollrath <jwollrath@web.de>,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Sun, 22 Oct 2023 13:06:25 -0400
In-Reply-To: <20231022161847.GAZTVLZ74T8B79v87p@fat_crate.local>
References: <20231022172700.48c515cf@mayene>
         <20231022161847.GAZTVLZ74T8B79v87p@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2023-10-22 at 18:18 +0200, Borislav Petkov wrote:
> + linux-scsi
> 
> On Sun, Oct 22, 2023 at 05:27:00PM +0200, Julian Wollrath wrote:
> > Dear maintainers,
> > 
> > on v6.6-rc6+ (git commit hash 1acfd2bd3f0d) I got the following
> > oops:

How to reproduce would be helpful.  Was this a cat of /proc/scsi/scsi?

Regards,

James

