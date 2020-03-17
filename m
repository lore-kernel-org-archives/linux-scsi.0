Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EACC10F29
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 13:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1142420772
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 13:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DxX6ePvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgCQNlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:41:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgCQNlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2020 09:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gbv7y7bVNyeKz7zfGV6EEYdTLGLit1jz1j4W2R6e7tg=; b=DxX6ePvyP+8VT3YwCSYuHRh0VU
        xxCpngerlHkbZaGsEDHGpuZnEZjF0baD4/ZJmGPR3I7/VDeAG0sBleqGDvuIS93/KgNGaqJESvuZ4
        7xb2NtJswsFLDCeE0o5IydbgEHnmknig4boIEvwos9tzz19Zofe1nopsdANBLmxmMxUx3zZpMj8wI
        Cd1Vych8G42nd/pP0mzeLgqjw60FEmkkjH/QpHjdFbh3C6xCElPChlfRP9Up9n+Ddb4Jm3hzCO7jC
        gJLmsdMVYH5LW8Dkv8V6rBxE9VR4hd0tNLAuCRu2G5Ss0v1wiP2jm2W0csM506Oy/C5Dnql6tSmXx
        T+/NrheQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jECTT-0001iF-Kg; Tue, 17 Mar 2020 13:41:39 +0000
Date:   Tue, 17 Mar 2020 06:41:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/42] docs: scsi: convert aic79xx.txt to ReST
Message-ID: <20200317134139.GA30968@infradead.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
 <e8a40337a2173f028c9ac569d3d71fd880f4fab5.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8a40337a2173f028c9ac569d3d71fd880f4fab5.1583136624.git.mchehab+huawei@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


If you touch this please remove the obsolete version history, and the
very out of data version information.  Same for aic7xxx and probably
a few other drivers as well.
