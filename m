Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA11C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352915AbiEDP7N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352823AbiEDP7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:59:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30B6426
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 08:55:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3B31C210E0;
        Wed,  4 May 2022 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651679734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Oa+li9Sl4zHn7Vb1UunpCoJkkO7QVyDYkICVgKNBvM=;
        b=Z14tVWMKMlTXiw7FK6PlVGMYti6E5MISC9CG2vKL0ZCumtry4k9ZiNaxHtwLE7nzO7pBJ9
        itzawtGLiBjkCwsMTZAMrI3fPWFrfALZTmDmmWRi+0pFVpqV/qYV2SrRT4ZhDO2jCJbYi2
        xCCx0FVR2SyiMWFHC0BLX6U0QRk89RQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2762132C4;
        Wed,  4 May 2022 15:55:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xpecNfWhcmItPAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 04 May 2022 15:55:33 +0000
Message-ID: <4a7f19b6330c3017c45074854cf86b04224e7706.camel@suse.com>
Subject: Re: lpfc: regression with lpfc 14.2.0.0 / Skyhawk: FLOGI failure
From:   Martin Wilck <mwilck@suse.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        David Bond <dbond@suse.com>, Hannes Reinecke <hare@suse.com>
Date:   Wed, 04 May 2022 17:55:33 +0200
In-Reply-To: <9d7e7a5613decc1737ef2601ebb2506890790930.camel@suse.com>
References: <9d7e7a5613decc1737ef2601ebb2506890790930.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-05-04 at 09:11 +0200, Martin Wilck wrote:
>=20
> Hints appreciated. Complete logs and additional debug data can be
> provided on request.

Further analysis by David showed that the FLOGI via FCoE was using the
VLAN ID.

Martin

