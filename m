From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/5] target: Use scsi helpers to build the sense data
 correctly
Date: Wed, 8 Jul 2015 03:17:38 -0700
Message-ID: <20150708101738.GC14466@infradead.org>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436188508-1539-5-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -7,6 +7,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/percpu_ida.h>
>  #include <linux/t10-pi.h>
> +#include <scsi/scsi_common.h>
>  #include <net/sock.h>
>  #include <net/tcp.h>

Please only add the include in the files that need it.  (And many of the
existing includes should be fixed up the same way, but that's a
different story).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
