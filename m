From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 15:36:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024223603.GF1563@beaverton.ibm.com>
References: <3DB7436E.9060100@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB7436E.9060100@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

Steven Dake [sdake@mvista.com] wrote:
> +static char scsi_hotswap_insert_by_scsi_id_usage[] = {
> +	"Usage: echo \"[host] [channel] [lun] [id]\" > insert_by_scsi_id\n"
> +};
> +

Why is the interface lun id istead of id lun.
The same for lun wwn instead of wwn lun.

-andmike
--
Michael Anderson
andmike@us.ibm.com

