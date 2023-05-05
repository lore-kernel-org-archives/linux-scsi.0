Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BCFC77B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 07:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjEEHtL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 03:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjEEHtL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 03:49:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE6615693
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 00:49:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5EDC367373; Fri,  5 May 2023 09:49:07 +0200 (CEST)
Date:   Fri, 5 May 2023 09:49:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 4/5] scsi: core: Only kick the requeue list if
 necessary
Message-ID: <20230505074907.GA13464@lst.de>
References: <20230503230654.2441121-1-bvanassche@acm.org> <20230503230654.2441121-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503230654.2441121-5-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good modulo the comment from Ming.
