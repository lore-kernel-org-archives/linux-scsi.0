From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] qla4xxx: overflow in qla4xxx_set_chap_entry()
Date: Wed, 13 Nov 2013 15:08:12 +0300
Message-ID: <20131113120812.GM5302@mwanda>
References: <20131113074811.GF25541@elgon.mountain>
 <3FC4AB8B47ECD546BCD4B361A64BEACD8C62AF37@avmb3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab3KMMIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2013 07:08:23 -0500
Content-Disposition: inline
In-Reply-To: <3FC4AB8B47ECD546BCD4B361A64BEACD8C62AF37@avmb3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

On Wed, Nov 13, 2013 at 11:52:37AM +0000, Vikas Chaudhary wrote:
> 
> 
> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Wednesday, 13 November 2013 1:18 pm
> To: Vikas <vikas.chaudhary@qlogic.com>, Adheer Chandravanshi
> <adheer.chandravanshi@qlogic.com>
> Cc: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J.
> Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>,
> "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
> Subject: [patch] [SCSI] qla4xxx: overflow in qla4xxx_set_chap_entry()
> 
> >We should cap the size of memcpy() because it comes from the network
> >and can't be trusted.
> 
> This patch is on assumption that data is coming from network,
> but in this case data come from application (iscsiadm) with correct length.
> 

No, that doesn't work.  We don't trust user space.

regards,
dan carpenter

