From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Thu, 22 Jun 2017 17:05:33 +0200
Message-ID: <1498143933.6002.18.camel@suse.com>
References: <20170616082755.22832-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48042 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdFVPFv (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 22 Jun 2017 11:05:51 -0400
In-Reply-To: <20170616082755.22832-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Hello Christoph,

On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq
> I/O
> path now that we had plenty of testing, and have I/O schedulers for
> blk-mq.  The module option to disable the blk-mq path is kept around
> for now.

Could you explain why you remove the option entirely rather than just
changing the default? Some distributions may wish to keep the ability
to choose the compiled-in default.

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
