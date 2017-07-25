From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH v2] scsi: qedf: Limit number of CQs
Date: Tue, 25 Jul 2017 10:33:18 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1707251032290.1057@n5127mncfb42q1.qlogic.org>
References: <20170725092243.7E0CD50870B@solo.franken.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725092243.7E0CD50870B@solo.franken.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 25 Jul 2017, 5:19am, Thomas Bogendoerfer wrote:

> From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> FCOE offloading failed with:
> 
> [qed_sp_fcoe_func_start:150(sp-0-3b:00.02)]Cannot satisfy CQ amount. CQs
> 		 requested 8, CQs available 6. Aborting function start
> [qed_fcoe_start:821()]Failed to start fcoe
> [__qedf_probe:3041]:6: Cannot start FCoE function.
> 
> The reason is a newly introduced check in the qed main part. This change
> also provides the information about how many CQs are available, so we
> simply limit the number of requested CQs..
> 
> Fixes: 3c5da9427802 ("qed: Share additional information with qedf")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
> 
> Changes in v2:
> - integrated suggested change from Chad Dupuis
> 
>  drivers/scsi/qedf/qedf.h      |  3 ++-
>  drivers/scsi/qedf/qedf_main.c | 20 +++++++++-----------
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 

V2 looks good.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
