Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A254CD37A7
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjIOUL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237398AbjIOULU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:11:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA833268F
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:11:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 91E211FD90;
        Fri, 15 Sep 2023 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694808667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMCGRWIbZ46AtNiZOy8MxUDMQGAuPbvtoIhLnO18TJk=;
        b=uS+HBO7QIBSsYinu1hNEwODgmKZyDcdBqCaBT5YCpsEPiai+QNhEysQbG7gNs57xEJOkJK
        ZF99SzpeuksfcWOh9/7fcmhTJaINT8bJYdERbnJdP6rNvRTsEf0TDNUVkjansb8eOisRjo
        mLz36ClHYCwCdSnsM0d8K6UF+ClOWpc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BDC11358A;
        Fri, 15 Sep 2023 20:11:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Cz0ZAFu6BGXhDAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:11:06 +0000
Message-ID: <0b96ba0e94e4ecd55392661eda69e590ed23faa1.camel@suse.com>
Subject: Re: [PATCH v11 04/34] scsi: Have scsi-ml retry scsi_probe_lun errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:11:06 +0200
In-Reply-To: <20230905231547.83945-5-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-5-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving
> them
> itself.
>=20
> There is one behavior change with this patch. We used to get a total
> of
> 3 retries for both UAs we were checking for. We now get 3 retries for
> each.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Martin Wilck <mwilck@suse.com>


