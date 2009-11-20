From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 0/7] bfa: update bfa driver to version 2.1.2.1
Date: Thu, 19 Nov 2009 21:39:59 -0800
Message-ID: <04391A4E90BB2149B010D22452FA168702063351@HQ-EXCH-6.corp.brocade.com>
References: <1258675713-17487-1-git-send-email-huangj@brocade.com>
 <1258688102.6363.722.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:28596 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZKTFj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 00:39:58 -0500
In-Reply-To: <1258688102.6363.722.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

> > This patch set updates bfa driver to version 2.1.2.1. It contains:
> >
> > - Bugs fixes from latest internal release (bfa driver version 2.1.0.0)
> > - Bug fixes received from upstream.
> > - Misc code cleanups & reorganization.
> 
> This description is incredibly terse.
> 
> Then seven patches with the only description as patch 1 through patch 7
> isn't really on.
> 
> It looks like from the above, you actually have three separate patches,
> two of which might need copying to stable ... if so, three patches with
> accurate descriptions would be gratefully accepted.
> 
> Thanks,
> 
> James
> 

James,

Sorry about the terse description. This patch set basically updates the current driver in scsi-misc-2.6 to our recently released 2.1 driver. We couldn't make it in upstream in our initial submission since it was not ready at that time. Except for the second item (2 fixes received from upstream, which you already added into rc fix tree but not in scsi-misc-2.6), the remaining changes come from our internal 2.1 GA driver which is intended to be included in 2.6.33 merge window. I divide them into 7 patches for the consideration of patch size. Moving forward, we will make incremental changes instead of big patches like this.

Thanks

Jing
