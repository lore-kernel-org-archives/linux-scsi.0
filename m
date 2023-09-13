Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB15ECA5537
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbjIMKzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 06:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239806AbjIMKzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 06:55:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0285F19BB
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 03:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vBdSKuOnDVWdTqq5GJzVd0JUkbItTU3DeZE2mzxQkdw=; b=qyPfPhZNCJeYOvpdAtflG8WUF0
        asg6+ugqroIjw5dJ3ro3ml9pp6XTWzmN25yB+wmm7lhIeEPM1pgJWlHAtShECH5vdODgmpW/gt5A3
        IG9E+D1TpcHxHCb3JVRfPf5lczhZkbKVwDhbYuXtpuzRdKOnKsOKc1eERKWnCV2ZNh/M6UnOGJGjD
        DlymeWk3NoOA/5ggLzUAtofghR156ljH3eyJbB8+rYZjOPO2pue6Ltnd/mRTZV6syHjO8K3bPd8wy
        HGw4HVCxZjFXYxrSnrZFqW76c8t2+YT42QJ4Ru1dXiDJjQnFAhqU3K9EuLTEFgx7FR+gSXUxzPT0B
        qWIwZg5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qgNWJ-005fqp-1x;
        Wed, 13 Sep 2023 10:54:55 +0000
Date:   Wed, 13 Sep 2023 03:54:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v3 1/9] qla2xxx: Add Unsolicited LS Request and Response
 Support for NVMe
Message-ID: <ZQGU/4vIEllze8Gx@infradead.org>
References: <20230821130045.34850-1-njavali@marvell.com>
 <20230821130045.34850-2-njavali@marvell.com>
 <ZPBE8AS+mazj+pBQ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPBE8AS+mazj+pBQ@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 31, 2023 at 12:44:48AM -0700, Christoph Hellwig wrote:
> Marting, I saw this made it to linux-next now, please revert it.
> qla2xxx hsa absolutely no business changing nvme-fc-driver.h without
> ACKs from the NVMe maintainers.

.. and it now made it to mainline and causes sparse warnings in the
core nvme-fc and lpfc code.

Nilesh, Martin, James, can someone please fix this up now?
