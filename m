Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D87C54EED
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 08:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbjAYIdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 03:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbjAYIdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 03:33:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C3E367DF
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 00:33:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 481DA21F37;
        Wed, 25 Jan 2023 08:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674635584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtbHFcY0LiqrinmaOb26dk2tmCdBlW+iqYG+bvrooCY=;
        b=iEeG/PMf52weJ1nSOiejmOW3zU6D+Ja/i9QttuRZWpyixRUkgnniliVx+xFan4zm9u4O/R
        pSsK/Gp73PaOcweU/sYjFTqozqXWDOwFIb8e3b8R+fjWy/1El+X6ODMlaumBTy5MOSUPh7
        L7pgPs+mDtDfQ9FHij/bV/r/Qo8ggws=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E79D91339E;
        Wed, 25 Jan 2023 08:33:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k5XrNj/p0GN2egAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 25 Jan 2023 08:33:03 +0000
Message-ID: <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
Subject: Re: The PQ=1 saga
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Li Zhong <lizhongfs@gmail.com>
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        Andrey Melnikov <temnota.am@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Date:   Wed, 25 Jan 2023 09:33:03 +0100
In-Reply-To: <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
         <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-24 at 17:41 -0800, Bart Van Assche wrote:
> On 1/24/23 16:01, Martin K. Petersen wrote:
> > I would like to revert commit 948e922fc446 ("scsi: core: map PQ=3D1,
> > PDT=3Dother values to SCSI_SCAN_TARGET_PRESENT").
>=20
> That sounds good to me.
>=20
> Bart.
>=20

I agree.

Martin
