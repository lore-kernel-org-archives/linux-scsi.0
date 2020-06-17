Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EA3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8280D21532
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592411264;
	bh=sJ0+xZvufHaqanlVtw0B2ZAHoNDz83+7vEK5jNtOutM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bi8Zo6UfsrFddVJwm5j+MtqbpZBJ627aOsjuW9KBdzLerBkkiUPaioxmTEIgSyPaz
	 sS+Hf9Lp1GgtnuXAyLyw07QG1I5U5kcaEiQThqoNteA/u2JMgxBJb/fPmDbWKsMifF
	 BleSYkPK/YDJXzj1O1ccskAD79MXO3z8c7ItN2Bc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgFQQ1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgFQQ0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 12:26:11 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C0F21532;
        Wed, 17 Jun 2020 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411171;
        bh=sJ0+xZvufHaqanlVtw0B2ZAHoNDz83+7vEK5jNtOutM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSRDLA842Vu3esci3uXCzddXNVomnmagvx8Z7gDMBPyHg41hZU5FXuriyvtRQfh2T
         n0Vi8myBOdmHDH9i+yqEs4y9JlLORdKK2Xkz6XIf+QXhjHt1M438aQR3nMAr1jg39A
         0p3Am8zzA1697b6nP5mad4ioPjT3/Wv/Bn4JmCZg=
Date:   Wed, 17 Jun 2020 09:26:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: UFS driver v2.1 spec crypto additions
Message-ID: <20200617162609.GB1138@sol.localdomain>
References: <20200617081841.218985-1-satyat@google.com>
 <20200617081841.218985-2-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617081841.218985-2-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 08:18:39AM +0000, Satya Tangirala wrote:
> Add the crypto registers and structs defined in v2.1 of the JEDEC UFSHCI
> specification in preparation to add support for inline encryption to
> UFS.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Stanley Chu had made a comment and provided a Reviewed-by at
https://lkml.kernel.org/linux-scsi/1589514936.3197.108.camel@mtkswgap22/.
Looks like that was missed?

- Eric
