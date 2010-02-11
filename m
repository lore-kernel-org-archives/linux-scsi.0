From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 03/11] qla4xxx: Link Down -> Mark all devices missing
Date: Thu, 11 Feb 2010 03:08:43 -0800
Message-ID: <20100211110843.GA8237@linux-qf4p>
References: <20100130062831.GD10274@linux-qf4p> <4B671A8A.3060204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:53973 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0BKLHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 06:07:32 -0500
Content-Disposition: inline
In-Reply-To: <4B671A8A.3060204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On Mon, 01 Feb 2010, Mike Christie wrote:
> 
> On 01/30/2010 12:28 AM, Ravi Anand wrote:
> > +
> > +	if (test_and_clear_bit(DPC_LINK_CHANGED,&ha->dpc_flags)) {
> > +		if (!test_bit(AF_LINK_UP,&ha->flags)) {
> > +		/* ---- link down? --- */
> > +			list_for_each_entry_safe(ddb_entry, dtemp,&ha->ddb_list, list) {
> > +			if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
> 
> Need some tabbing.
> 

Will do.

Thanks
Ravi

