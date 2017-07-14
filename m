From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Fri, 14 Jul 2017 12:16:21 +0300
Message-ID: <20170714091621.u4nngclndjhvczne@mwanda>
References: <20170714074603.7mi6jshrz6zfru4b@mwanda>
 <20170714090111.GA8497@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32576 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdGNJQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 05:16:32 -0400
Content-Disposition: inline
In-Reply-To: <20170714090111.GA8497@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 14, 2017 at 11:01:11AM +0200, Johannes Thumshirn wrote:
> On Fri, Jul 14, 2017 at 10:46:03AM +0300, Dan Carpenter wrote:
> >    761          case SG_DXFER_FROM_DEV:
> >    762                  if (hp->dxfer_len < 0)
> >                             ^^^^^^^^^^^^^^^^^
> > Not possible.
> 
> Yup and thanks to:
> 647         else
> 648                 hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
> 649         hp->dxfer_len = mxsize;
> 
> I should've noticed that earlier.
> Care to send a patch or want me to do?
> 

Could you send the patch?

regards,
dan carpenter
