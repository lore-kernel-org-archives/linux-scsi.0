From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 6/6] statistics infrastructure - exploitation: zfcp
Date: Wed, 14 Dec 2005 16:59:00 +0000
Message-ID: <20051214165900.GA26580@infradead.org>
References: <43A044E6.7060403@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:26063 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932400AbVLNQ7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 11:59:02 -0500
Content-Disposition: inline
In-Reply-To: <43A044E6.7060403@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, linux-scsi@vger.kernel.org

> +	atomic_t		read_num;
> +	atomic_t		write_num;
> +	struct statistic_interface	*stat_if;
> +	struct statistic		*stat_sizes_scsi_write;
> +	struct statistic		*stat_sizes_scsi_read;
> +	struct statistic		*stat_sizes_scsi_nodata;
> +	struct statistic		*stat_sizes_scsi_nofit;
> +	struct statistic		*stat_sizes_scsi_nomem;
> +	struct statistic		*stat_sizes_timedout_write;
> +	struct statistic		*stat_sizes_timedout_read;
> +	struct statistic		*stat_sizes_timedout_nodata;
> +	struct statistic		*stat_latencies_scsi_write;
> +	struct statistic		*stat_latencies_scsi_read;
> +	struct statistic		*stat_latencies_scsi_nodata;
> +	struct statistic		*stat_pending_scsi_write;
> +	struct statistic		*stat_pending_scsi_read;
> +	struct statistic		*stat_erp;
> +	struct statistic		*stat_eh_reset;

NACK.  pretty much all of this is generic and doesn't belong into an LLDD.
We already had this statistics things with emulex and they added various
bits to the core in response.

