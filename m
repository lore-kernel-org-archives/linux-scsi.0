From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 1/6: scsi_largelun and scsi_sparselun
Date: Sun, 18 Apr 2004 20:18:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418201852.A3393@infradead.org>
References: <20040418185820.GD4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:56839 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263948AbUDRTSy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:18:54 -0400
Content-Disposition: inline
In-Reply-To: <20040418185820.GD4868@tpkurt.garloff.de>; from garloff@suse.de on Sun, Apr 18, 2004 at 08:58:20PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Sun, Apr 18, 2004 at 08:58:20PM +0200, Kurt Garloff wrote:
> +static int scsi_sparselun;
> +module_param_named(scsi_sparselun, scsi_sparselun, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scsi_sparselun,
> +		 "Assume sparse LUNs for all SCSI devices");
> +
> +static int scsi_largelun;
> +module_param_named(scsi_largelun, scsi_largelun, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scsi_largelun,
> +		 "Assume all SCSI-2 devs support more than 8 LUNs");

The names are badly chosen.  On the bootline commandline they already
have a scsi_mod. prefix, so the additional scsi_ is superflous.

