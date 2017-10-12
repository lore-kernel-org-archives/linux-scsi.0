From: weiping zhang <zhangweiping@didichuxing.com>
Subject: Re: [PATCH] scsi: sd: add check for changing allow_restart
Date: Thu, 12 Oct 2017 14:22:40 +0800
Message-ID: <20171012062239.GA11099@source.didichuxing.com>
References: <20170927165313.GA36250@localhost.didichuxing.com>
 <yq1d15tha5x.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:27722 "EHLO
        BJEXCAS003.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750774AbdJLGh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 02:37:57 -0400
Content-Disposition: inline
In-Reply-To: <yq1d15tha5x.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Wed, Oct 11, 2017 at 01:22:18PM -0400, Martin K. Petersen wrote:
> 
> weiping,
> 
> > /sys/class/scsi_disk/0:2:0:0/allow_restart can be changed to 0 unexpectly by
> > writing invalid string, like following:
> >
> > echo asdf > /sys/class/scsi_disk/0:2:0:0/allow_restart
> 
> Please switch to kstrtobool() and fix up manage_start_stop as well.
> 
> Thanks!
> 
Thanks, I'll send v2 later.
