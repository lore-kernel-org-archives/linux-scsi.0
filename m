Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B84C77B61
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Apr 2023 06:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDXGwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 02:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjDXGw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 02:52:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E2A3AA6
        for <linux-scsi@vger.kernel.org>; Sun, 23 Apr 2023 23:52:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C13A68B05; Mon, 24 Apr 2023 08:52:07 +0200 (CEST)
Date:   Mon, 24 Apr 2023 08:52:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com
Subject: Re: [PATCH v3 3/3] scsi: libsas: factor out
 sas_check_fanout_expander_topo()
Message-ID: <20230424065207.GC11582@lst.de>
References: <20230421093744.1583609-1-yanaijie@huawei.com> <20230421093744.1583609-4-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421093744.1583609-4-yanaijie@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
