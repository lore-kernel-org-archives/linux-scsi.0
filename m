From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Mon, 4 Apr 2016 07:22:03 -0700
Message-ID: <5702788B.7000509@sandisk.com>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
 <1458684196-15923-5-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:18608
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755719AbcDDOWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 10:22:08 -0400
In-Reply-To: <1458684196-15923-5-git-send-email-mlin@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

On 03/22/16 15:03, Ming Lin wrote:
> From: Ming Lin <ming.l@ssi.samsung.com>
>
> Rename SCSI_MAX_SG_SEGMENTS to SG_CHUNK_SIZE, which means the amount
> we fit into a single scatterlist chunk.
>
> Rename SCSI_MAX_SG_CHAIN_SEGMENTS to SG_MAX_SEGMENTS.
>
> Will move these 2 generic definitions to scatterlist.h later.
>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
> ---
>   drivers/ata/pata_icside.c           |  2 +-
>   drivers/infiniband/ulp/srp/ib_srp.c |  4 ++--
>   drivers/scsi/arm/cumana_2.c         |  2 +-
>   drivers/scsi/arm/eesox.c            |  2 +-
>   drivers/scsi/arm/powertec.c         |  2 +-
>   drivers/scsi/esas2r/esas2r_main.c   |  4 ++--
>   drivers/scsi/hisi_sas/hisi_sas.h    |  2 +-
>   drivers/scsi/mpt3sas/mpt3sas_base.c |  4 ++--
>   drivers/scsi/mpt3sas/mpt3sas_base.h |  2 +-
>   drivers/scsi/scsi_debug.c           |  2 +-
>   drivers/scsi/scsi_lib.c             | 34 +++++++++++++++++-----------------
>   drivers/usb/storage/scsiglue.c      |  2 +-
>   include/scsi/scsi.h                 |  8 ++++----
>   include/scsi/scsi_host.h            |  2 +-
>   14 files changed, 36 insertions(+), 36 deletions(-)

Hello Ming,

The ib_srp changes in this patch look fine to me.

Bart.
