From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] qla4xxx: remove some bogus casts
Date: Tue, 18 Aug 2015 11:47:26 +0300
Message-ID: <20150818084726.GG5610@mwanda>
References: <20150817143647.GA23820@mwanda>
 <55D2B879.7040906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47233 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbHRIrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 04:47:25 -0400
Content-Disposition: inline
In-Reply-To: <55D2B879.7040906@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: QLogic-Storage-Upstream@qlogic.com, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, Aug 17, 2015 at 09:45:45PM -0700, Bart Van Assche wrote:
> On 08/17/2015 07:36 AM, Dan Carpenter wrote:
> >These casts are wrong and unnecessary.  They annoy static checkers
> >because they imply we are planning to write sizeof(long) bytes to a
> >sizeof(u32) buffer which would corrupt memory.
> 
> Hello Dan,
> 
> Can you verify whether that patch is still needed after having
> applied the patch series I posted in July (and that was acknowledged
> by QLogic): http://thread.gmane.org/gmane.linux.scsi/103135 ?
> 

I think it is needed still?

regards,
dan carpenter

