Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBB4CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbjIOViP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237786AbjIOVhr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:37:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F74B8
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:37:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C21CF2191A;
        Fri, 15 Sep 2023 21:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694813860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lua5GCLg03U43C63KeZsPJ/YFS0eceXgW0ZOu6+byM4=;
        b=r/rlS/HfGr+9XWV4f+4oQYMafLRP/WN7DBck9iVjd2+HgB7Pu3MGS1TdW70PpBEcvyYOm+
        wXXvPm4lHryYaN6jQglCXoibAg8Wjj9PE6NU1mDU03b11kSYSYDtEmp6i8azflbBc6cJG6
        K9bHTtfvtw2c8xMIVzKSXjvfKDzPetY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 743E513251;
        Fri, 15 Sep 2023 21:37:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +VnDGqTOBGUpKgAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:37:40 +0000
Message-ID: <e3cb7ea5a8c625ca6803c060503514d28ee1bfee.camel@suse.com>
Subject: Re: [PATCH v11 29/34] scsi: ufs: Have scsi-ml retry start stop
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:37:39 +0200
In-Reply-To: <20230905231547.83945-30-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-30-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has scsi-ml retry errors instead of driving them itself.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Martin Wilck <mwilck@suse.com>
