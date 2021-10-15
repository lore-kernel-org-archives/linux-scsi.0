Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F028C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 04:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EDAC60F41
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 04:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhJOEjK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 00:39:10 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:41459 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbhJOEjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 00:39:10 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HVtlf1hz1z4xbL;
        Fri, 15 Oct 2021 15:37:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634272623;
        bh=gy6IOQq1/i045R/X3xzbUqQQYRLl5v+byr2Go9PBGx0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UGBBJEIei0/FmxdXzeDsBrNFu8QhOtzqfeV4lfTTbyRZi+9YRE6me9r8NzAhfz4s4
         L3DesDbRYKu789A0p3O+zYAGtMcze41SJvppc8xp26lv25lj9CHt58M7v9e6FxD4MF
         Yyl/JEmq1qIyUhMHvwdPfRq0aAUPLTUZH7+YGWwXiZUmuVgCUgx6SojZBSzNrCqFtg
         Lius0aDSA3WdR+eL1PkhYKJrpYnW3CiOMXeK0ekXMBF+KdeM68ArSxUwZf9c0WWWZz
         sAtfAAhW4Cm52C3YM5oa90SF4J/GsSwGCz55TIy2jSoP3r2qWOZhGMPdeTEf4plpSB
         2MwWV0YyRx/dg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>, tyreld@linux.vnet.ibm.com
Cc:     brking@linux.vnet.ibm.com, james.bottomley@hansenpartnership.com,
        linuxppc-dev@lists.ozlabs.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in
 initialize_event_pool
In-Reply-To: <bbab1043-ee3a-6d5b-7ff5-ea5ed84e9fb8@linux.ibm.com>
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <bbab1043-ee3a-6d5b-7ff5-ea5ed84e9fb8@linux.ibm.com>
Date:   Fri, 15 Oct 2021 15:36:56 +1100
Message-ID: <878ryuykd3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tyrel Datwyler <tyreld@linux.ibm.com> writes:
> Just stumbled upon this trivial little patch that looks to have gotten lost in
> the shuffle. Seems it even got a reviewed-by from Brian [1].
>
> So, uh I guess after almost 3 years...ping?

It's marked "Changes Requested" here:

  https://patchwork.kernel.org/project/linux-scsi/patch/1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com/


If it isn't picked up in a few days you should probably do a resend so
that it reappears in patchwork.

cheers
