From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/11] qla4xxx: Link Down -> Mark all devices missing
Date: Mon, 01 Feb 2010 12:16:42 -0600
Message-ID: <4B671A8A.3060204@cs.wisc.edu>
References: <20100130062831.GD10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49103 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab0BASRO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:17:14 -0500
In-Reply-To: <20100130062831.GD10274@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 01/30/2010 12:28 AM, Ravi Anand wrote:
> +
> +	if (test_and_clear_bit(DPC_LINK_CHANGED,&ha->dpc_flags)) {
> +		if (!test_bit(AF_LINK_UP,&ha->flags)) {
> +		/* ---- link down? --- */
> +			list_for_each_entry_safe(ddb_entry, dtemp,&ha->ddb_list, list) {
> +			if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)

Need some tabbing.

> +				qla4xxx_mark_device_missing(ha, ddb_entry);
> +			}
> +		}
> +	}
>   }
>
>   /**

