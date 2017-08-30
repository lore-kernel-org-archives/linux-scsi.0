From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 15:36:19 +0300
Message-ID: <20170830123619.3yzvxdz6kaiwuc4z@mwanda>
References: <CAER+mfKPOt03DmPB4FTCjVvQ=2uRSMVbBHP-3CdoG+mQnSiYFw@mail.gmail.com>
 <20170830122106.dmdfril4kwi4p5e5@mwanda>
 <CAER+mf+sKmuDHmdsx_QfFgA4iNCQkhPAOvJBq3ydKpFXh2hJRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48031 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdH3Mgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 08:36:50 -0400
Content-Disposition: inline
In-Reply-To: <CAER+mf+sKmuDHmdsx_QfFgA4iNCQkhPAOvJBq3ydKpFXh2hJRQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shqking <shqking@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, Joe Carnuccio <joe.carnuccio@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Wed, Aug 30, 2017 at 08:28:52PM +0800, shqking wrote:
> Hi,
> 
> Glad to see it is fixed.
> 
> Can I apply for a CVE ID for this bug?
> 

We don't handle that on this list.  You'd need to ask on
oss-security@lists.openwall.com.

regards,
dan carpenter
