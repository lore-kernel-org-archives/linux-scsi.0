From: Ewan Milne <emilne@redhat.com>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Mon, 23 Mar 2015 09:54:10 -0400
Message-ID: <1427118850.19806.86.camel@localhost.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	 <1426859486.19806.30.camel@localhost.localdomain>
	 <20150320153104.086f3b46@leda.localdomain>
	 <1426863883.19806.65.camel@localhost.localdomain>
	 <20150323095308.196dd451@leda.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbbCWNy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2015 09:54:26 -0400
In-Reply-To: <20150323095308.196dd451@leda.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Hesse <list@eworm.de>, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Mon, 2015-03-23 at 09:53 +0100, Christian Hesse wrote:
> 
> I reverted these two commits:
> 
> commit 3a9794d32984b67a6d8992226918618f0e51e5d5
> Author: Brian King <brking@linux.vnet.ibm.com>
> Date:   Thu Jan 29 15:54:40 2015 -0600
> 
>     sd: Fix max transfer length for 4k disks
> 
> commit bcdb247c6b6a1f3e72b9b787b73f47dd509d17ec
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Tue Jun 3 18:45:51 2014 -0400
> 
>     sd: Limit transfer length
>  
> iSCSI device still fails, max_sectors_kb is still set to 32767. Looks like
> there is another change that introduced the regression.

OK, as Mike Christie suggested, see if you can get a wireshark/tcpdump
trace with both the 3.18 (working) and 3.19 (failing) kernels.

-Ewan


