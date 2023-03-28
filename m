Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F02C76195
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 07:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjC1Hwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1Hwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 03:52:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29516B6
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 00:52:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D59CE1FD81;
        Tue, 28 Mar 2023 07:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679989966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKS7oIq+t2ndrAOcku009L5MpUwMTmCXy0MoElCrtLc=;
        b=Y4HvdZxTPybgOc4cp1LSdz2cKP/Rbn6UJYSjXzTVV4tzSaqFC086EqeNa+ajtZAAqx8g6Q
        mylUTeMd1nZEAXjH76/uAlfy//9Zzq0ASO4JZAzlAEl5yM3rPjbZLQybFI/lkt4yPCwm9Q
        P6MtpwKuOkdQXvV5L1dPPbDt975jZzo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D7931390D;
        Tue, 28 Mar 2023 07:52:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DC/+IM6cImR9DwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 28 Mar 2023 07:52:46 +0000
Message-ID: <207a735ad9023da3d13b434ba70e34a5406f310c.camel@suse.com>
Subject: Re: [RFC PATCH 0/3] sg3_utils: udev rules: restrict use of
 ambiguous device IDs
From:   Martin Wilck <mwilck@suse.com>
To:     dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Franck Bui <fbui@suse.de>, dm-devel@redhat.com,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
Date:   Tue, 28 Mar 2023 09:52:45 +0200
In-Reply-To: <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
References: <20230327132459.29531-1-mwilck@suse.com>
         <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-03-27 at 19:58 -0400, Douglas Gilbert wrote:
>=20
> Lets see if anything happens. Applied as sg3_utils revision 1019 and
> pushed to https://github.com/doug-gilbert/sg3_utils=A0.
>=20
> Didn't see any effect on an Ubuntu 22.10 when sg3_utils deb package
> built and installed. No sign of 00-scsi-sg3_config.rules being placed
> anywhere by Ubuntu. Does Suse install those rules?

No, not yet. That's why I sent these patches, I intend to get rid of
the legacy symlinks on openSUSE with upstream's blessing.

Regards,
Martin


