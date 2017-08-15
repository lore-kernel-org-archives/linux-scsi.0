From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi: default to scsi-mq"
Date: Mon, 14 Aug 2017 22:58:23 -0400
Message-ID: <yq1lgmlwn8w.fsf@oracle.com>
References: <20170813174422.16197-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170813174422.16197-1-hch@lst.de> (Christoph Hellwig's message
        of "Sun, 13 Aug 2017 19:44:22 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> Defaulting to scsi-mq in 4.13-rc has shown various regressions
> on setups that we didn't previously consider.  Fixes for them are
> in progress, but too invasive to make it in this cycle.  So for
> now revert the commit that defaults to blk-mq for SCSI.  For 4.14
> we'll plan to try again with these fixes.
>
> This reverts commit 5c279bd9e40624f4ab6e688671026d6005b066fa.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
