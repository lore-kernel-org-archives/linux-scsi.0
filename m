Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D82BC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FED2063A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GkPBsEAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDVGez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgDVGez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:34:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA9EC03C1A6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 23:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WapDg+CTk9EpE+jlQ2cxMBOUcjKYj/Rw/rFobOw4BI0=; b=GkPBsEAngkTgVPl73QcL0Ky2v5
        WrBI3rXt3O4t0QE/pzq48o1axR9OD5s6d73bwgjKiObmZ14b4/AvJ+8xnUqVCxSBCogSN5lkdTRR8
        klbPP+6P1Ok+9/Qmua8yfI+4YxSRJdgSudbCS0fhIaHiwob7TuyHsnhJMAN6fiGdftJQRcx6i3Tv2
        ySCag53VhFTYM2lM0GqKpT3G93WTtkBaMDKphFT99zuopCRc6jxpwXf//up5WoeWs22uXToEE7cZg
        397ZJxPtlns64zXTXsRQm5q/NcMn6LHKprf8ETjiIZOJDsU6Ru1uSoPrcS+wec8lzxc4COQ3tUbro
        gB1JrqAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR8yF-0005oq-7k; Wed, 22 Apr 2020 06:34:55 +0000
Date:   Tue, 21 Apr 2020 23:34:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v1 2/5] mpt3sas: Rename function name is_MSB_are_same
Message-ID: <20200422063455.GC20318@infradead.org>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-3-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586957125-19460-3-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 09:25:22AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Renamed is_MSB_are_same() to mpt3sas_check_same_4gb_region()
> for better readability.

s/Rename function name is_MSB_are_same/rename is_MSB_are_same/rename/

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
