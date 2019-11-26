Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83945C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 16:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A822075C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 16:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfKZQzg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:55:36 -0500
Received: from verein.lst.de ([213.95.11.211]:41703 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbfKZQzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 11:55:35 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 346BB68C4E; Tue, 26 Nov 2019 17:55:34 +0100 (CET)
Date:   Tue, 26 Nov 2019 17:55:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/11] scsi: add scsi_host_flush_commands() helper
Message-ID: <20191126165533.GD8204@lst.de>
References: <20191120103114.24723-1-hare@suse.de> <20191120103114.24723-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191120103114.24723-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

flush is such a heavіly overloaded term.  What about
scsi_host_complete_all_commands?
