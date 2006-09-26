From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [patch 20/28] drivers/message/fusion/linux_compat.h Removal of old code
Date: Tue, 26 Sep 2006 12:25:14 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7034FB86@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48097 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751265AbWIZSZ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 14:25:27 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, michal.k.k.piotrowski@gmail.com

Jeff Garzik wrote:

> 
> Why?  That's against the general kernel policy...
> 
> As an example, when maintaining libata for 2.4 kernels as well as 2.6 
> kernels, I had a libata-compat.h file, and always just patched the 
> include into the kernel source at the same time I patched in the 
> libata-compat.h contents.
> 

This is merely a request is all.
Supporting Red Hat and SuSE distro's is why I ask. 
I don't care about 2.4 kernel.  My compatibility 
changes I support occur between 2.6 kernels releases, 
such example is 2.6.17 and 2.6.18; e.g. SLES10 versus RHEL5
with sas transport changes.  And they pull from upstream, 
and I support them with interim bug fix's.

Eric
