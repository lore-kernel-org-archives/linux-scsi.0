From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Some drives failing on SCT Write Same
Date: Fri, 9 Sep 2016 15:24:28 -0400
Message-ID: <20160909192428.GA25988@htj.duckdns.org>
References: <CAJ48U8VJDSzQWuNgG1mnBG_6FvSx5Arc=n6YsH-vxKrt=skWqw@mail.gmail.com>
 <20160909164419.12978-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35691 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752299AbcIITYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 15:24:31 -0400
Content-Disposition: inline
In-Reply-To: <20160909164419.12978-1-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: Mike Krinkin <krinkin.m.u@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, shaun.tancheff@seagate.com

On Fri, Sep 09, 2016 at 11:44:19AM -0500, Shaun Tancheff wrote:
> Restrict support SCT Write Same to devices which also support ZAC where 
> support is required.
> 
> Reported-by: Mike Krinkin <krinkin.m.u@gmail.com>
> Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>

Applied to libata/for-4.9.

Thanks.

-- 
tejun
