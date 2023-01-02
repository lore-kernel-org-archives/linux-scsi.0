Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E23C3DA7A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Jan 2023 11:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjABLRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Jan 2023 06:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjABLRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2023 06:17:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067F8630D
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2023 03:17:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B6B4E20AB9;
        Mon,  2 Jan 2023 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672658246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JnFRPiQfA35VH0t8dQSJLp6vMkZy9UsXD2KpC3W5hs=;
        b=LvdFbSrlZ1O4JvnQJDCVE03zVAJOqzxfwho4xU4oIM4qTeWwp7FABNRE87APFKrGIhds18
        Dm2dz1mhm+qp/l9wRS5cvJy7uwbXWvVUfCOP3qH6pKBBa2diJws1o8C1Q8+aXyLnFdg8Kw
        JZVKjM89U5w/nOyVGKaFq+Bl51H0XzI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E60F13427;
        Mon,  2 Jan 2023 11:17:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n2xWIUa9smPxawAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 02 Jan 2023 11:17:26 +0000
Message-ID: <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
From:   Martin Wilck <mwilck@suse.com>
To:     martin.petersen@oracle.com, Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Mon, 02 Jan 2023 12:17:25 +0100
In-Reply-To: <Y15lk+CPsjJ801iY@infradead.org>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
         <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
         <Y15lk+CPsjJ801iY@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

On Sun, 2022-10-30 at 04:52 -0700, Christoph Hellwig wrote:
> On Fri, Oct 28, 2022 at 02:46:55PM +0530, Sreekanth Reddy wrote:
> > Remove the usage of dma_get_required_mask() API.
> > Directly set the DMA mask to 63/64 if the system
> > is a 64bit machine.
> >=20
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>=20
> Looks good:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>

is anything blocking mainline inclusion of this patch?

Regards
Martin W.

