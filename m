Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C169CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbjIOVC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbjIOVBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:01:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1511AC
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:00:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 440002188F;
        Fri, 15 Sep 2023 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694811639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxbS3dVOrRjNWDqLgC5P3CPZDsIRiYuEXn+IjNvtY2g=;
        b=uuk+ANed+kMzmW7AvPcIdtUjUGXIFAUgEH39yEcCTo50STzcmOnEdGO2QhEXeHQEaQ2AYy
        /FnsLYV8tMIvkxqvoAWS6ckvJJ05Mfeb2QlCAEWE69uxLcMQMM++ORdhs0NGSu69YVUsAq
        jUNe/aAwa83Rf0mlX0mj2uUCNtL8Tac=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E9C0F13251;
        Fri, 15 Sep 2023 21:00:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lmdZN/bFBGUSHgAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:00:38 +0000
Message-ID: <893f015815a2b1548193f6c2854d604da1befd5f.camel@suse.com>
Subject: Re: [PATCH v11 17/34] scsi: spi: Have scsi-ml retry spi_execute
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:00:38 +0200
In-Reply-To: <20230905231547.83945-18-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-18-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has spi_execute have scsi-ml retry errors instead of driving
> them.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

