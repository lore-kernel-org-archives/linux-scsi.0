Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EE2C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiK3KDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiK3KDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:03:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5980124097
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wb/VUMVx/m8yfARfErIEm+hPeEHdyYBMREHC1m6Olr4=; b=OdszqyKV1QRreHMXKGvC330gdB
        3aMfI/SaU1mrPTIpNRZq9dExqJtKuYi9gjk6Wk3xKi9YVcz6hP/k67pwHjRasHJJLnSkYUUmnTZBn
        fA1wVHaLyf80CmRBvTrqYnkzyW1sKq3bMRS3OqVm48HMWImb03OCO763QD5NlKjuo01kcCEII1pOF
        2vy31n8cg6byGJtzem7UkXjrLtUJ2HuJrbqg1ogx1rGUU5HTlxwvf6nrwPWjdCf9JwVzL3eWSnrgS
        o4DmIIQ37BUU01cnX7E7tZJMrcLPhGYlDkNuvmbn7ezKP88hrnZNm1p8HZmMuPKPmyxLHUhUDgI31
        jGjgRI0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0JwI-00FJQr-8Z; Wed, 30 Nov 2022 10:03:38 +0000
Date:   Wed, 30 Nov 2022 02:03:38 -0800
From:   "hch@infradead.org" <hch@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Message-ID: <Y4cqegAv4SlFq6ci@infradead.org>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
 <Y4cp5S4AWV7+Sw3T@infradead.org>
 <e918ff92-4b39-3a4e-21b9-2d6408873161@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e918ff92-4b39-3a4e-21b9-2d6408873161@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 30, 2022 at 10:02:20AM +0000, Johannes Thumshirn wrote:
> But what's the reasoning behind it? All other trace events
> are in include/trace/events/.

No, they aren't.  Do a quick grep for TRACE_SYSTEM to show they mostly
are with the actual drivers and subsystems.
