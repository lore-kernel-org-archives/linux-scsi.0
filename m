Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EC0EB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 07:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjFZH6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 03:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjFZH6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 03:58:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257D110C0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 00:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O6+lIU+LXkTqESH/8jbXNsww/I0TCibC28mP6iZ6GPc=; b=1Xt3egl6PdtJnDnmJ7qBZbL1yT
        94BHPxW0zvC+p66kU0syuuofi0rRnlhLZmN1OkyeIX6SnTQNk+1q9Fc4OmPb6TciUBiBZWf6SBJQg
        fS4Vj93T4P7IxrsuU1lzZDi5BEc7ALFMKbD9eZ33QEWcxH3XOSyx0OBvazyWvUlDlgsk74/LWF3+M
        4EbrTbpnoJfUKbeD9MxnVCu/3VLhbFmy1eHMYzZOSWnv9ALyVduNAd11Kd24yqeCvaJSxpvs4pA28
        vo6+N7pBKn266aVa3Mlbex8oIkcYQkC7Uj4WBl8spPTS4GJ6qddMKRMKhBCvX5o4MM1uFq/QkuP0L
        9dmdfpkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qDh7S-009bYz-2E;
        Mon, 26 Jun 2023 07:58:42 +0000
Date:   Mon, 26 Jun 2023 00:58:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH] scsi: Simplify scsi_cdl_check_cmd()
Message-ID: <ZJlFMkijM2B6TQt3@infradead.org>
References: <20230623002912.808251-1-dlemoal@kernel.org>
 <ZJUwQvdRyr1v6wVX@infradead.org>
 <27177663-6ead-7a51-1037-1412a2b64d52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27177663-6ead-7a51-1037-1412a2b64d52@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 23, 2023 at 04:26:09PM +0900, Damien Le Moal wrote:
> On 6/23/23 14:40, Christoph Hellwig wrote:
> >> +	 * See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES.
> > 
> > /one/on/ or even on the?
> 
> The spec has that as "One_command parameter data format", as opposed to the
> other format which is "All_command parameter data format". Will re-phrase it
> exactly like that.

Oh, ok.
