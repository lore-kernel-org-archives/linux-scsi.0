From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] remove MULTI_LUN config option
Date: Wed, 3 Sep 2003 04:20:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902182009.GL1941@krispykreme>
References: <20030902021145.GC1941@krispykreme> <3F5400E6.3000104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:51592 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263840AbTIBSU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2003 14:20:56 -0400
Content-Disposition: inline
In-Reply-To: <3F5400E6.3000104@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org


Hi,

> I like the patch, but I worry about the above piece.  I would think that 
> a better patch might make NAC_SCANLUN, LUN_CHECK (tmscsim.c), and 
> similar bits conditional on the module_param you mention?  Ditto for the 
> loops which are now unconditionally executed.  They would still need to 
> be conditional on a runtime variable, right?

Yep, we should be able to use max_scsi_luns to select these things. Im
wondering why these #ifdefs were there in the first place and if it was
the result of a copy from another driver or there really is a need to
do this.

Anton
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

> I like the patch, but I worry about the above piece.  I would think that 
> a better patch might make NAC_SCANLUN, LUN_CHECK (tmscsim.c), and 
> similar bits conditional on the module_param you mention?  Ditto for the 
> loops which are now unconditionally executed.  They would still need to 
> be conditional on a runtime variable, right?

Yep, we should be able to use max_scsi_luns to select these things. Im
wondering why these #ifdefs were there in the first place and if it was
the result of a copy from another driver or there really is a need to
do this.

Anton
