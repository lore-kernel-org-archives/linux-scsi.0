Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BFAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 May 2022 05:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbiEPF5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 01:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiEPF5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 01:57:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF84D192A9
        for <linux-scsi@vger.kernel.org>; Sun, 15 May 2022 22:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZmUVXw2TXT+1fnZzaILAqv/PirCzLaVEwhdxHx/wtD0=; b=WkjSFqUYIumyDfagI+HhVwSVXv
        0eeQezWeydyzVEfQ6K+x31U3Bs8PPk+3a5/ggrg2duYRD0B8UxIkGOuPNuKsr5AFn009DBOfcUt52
        v6XfY0HfQerQnzt/vjY+NLdftLZgSGhH5aiN4pWWNPdpJMMQllH7XkypN3kCsY6gIu8VN5MTf8fqA
        W1dv8aMLi9JIo0incAnNsy0Z3+2mhP/dcWWn8Qr5KqRmG19lCk88Wj2XuuMLGA2ue/FD+Ss9kU9E8
        DFpKRo2ALSQGYJAl7pfxfoQjLxKEttGB/WChUZ0Gz20fRvCZXSQG1pYGO4UszK3UehAhyGZWzsbZY
        fGN2HC+g==;
Received: from 213-225-11-122.nat.highway.a1.net ([213.225.11.122] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqTjl-0065zY-NO; Mon, 16 May 2022 05:57:46 +0000
Date:   Mon, 16 May 2022 07:57:42 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: Re: [PATCH 1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
Message-ID: <YoHn1hcszJIAHN/j@infradead.org>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-2-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510200028.37399-2-jsmart2021@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 10, 2022 at 01:00:25PM -0700, James Smart wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
> 
> Add nvme_fc_io_getuuid() to the nvme-fc transport.
> The routine is invoked by the fc LLDD on a per-io request basis.
> The routine translates from the fc-specific request structure to
> the bio and the cgroup structure in order to obtain the fc appid
> stored in the cgroup structure. If a value is not set or a bio
> is not found, a NULL appid (aka uuid) will be returned to the LLDD.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

I'm fine with picking this up through the scsi tree:

Acked-by: Christoph Hellwig <hch@lst.de>
