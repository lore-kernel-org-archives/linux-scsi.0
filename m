From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 0/3] scsi: qedf: Fix a return value + some cleanups
Date: Mon, 12 Jun 2017 10:03:30 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1706121002340.964@n5127mncfb42q1.qlogic.org>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 11 Jun 2017, 2:16am, Christophe JAILLET wrote:

> This patch serie first fixes a case where an error code was missing.
> The 2 other patches are just cleanups in the same area.
> 
> Christophe JAILLET (3):
>   scsi: qedf: Fix a return value in case of error in
>     'qedf_alloc_global_queues'
>   scsi: qedf: Use 'dma_zalloc_coherent' to reduce code verbosity.
>   scsi: qedf: Merge a few quoted strings split across lines
> 
>  drivers/scsi/qedf/qedf_main.c | 38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)
> 
> 

All are sensible small improvements.  Ack the series.

series-acked-by: Chad Dupuis <chad.dupuis@cavium.com>
