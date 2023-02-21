Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE7DC64EC7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 17:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbjBURf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbjBURf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 12:35:26 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B3E233FD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 09:35:24 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4EFCA68AFE; Tue, 21 Feb 2023 18:35:21 +0100 (CET)
Date:   Tue, 21 Feb 2023 18:35:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Message-ID: <20230221173521.GA13772@lst.de>
References: <20230221095708.29094-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221095708.29094-1-njavali@marvell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 21, 2023 at 01:57:08AM -0800, Nilesh Javali wrote:
> CPU: 61 PID: 6064 Comm: nvme Kdump: loaded Not tainted 6.2.0-rc1 #3

Well, that's a reall old -rc.

This should be fixed by: 

commit 98e3528012cd571c48bbae7c7c0f868823254b6c
Author: Ross Lagerwall <ross.lagerwall@citrix.com>
Date:   Fri Jan 20 17:43:54 2023 +0000

    nvme-fc: fix initialization order
