From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Add compat_ioctl to mptctl
Date: Fri, 21 Jan 2005 17:33:27 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CF5EDF2@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34523 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262628AbVAVAeE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2005 19:34:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This patch is good to go. Thanks.

On Thursday, January 20, 2005 8:44 PM, Andi Kleen wrote:
> > 
> > One request is in compat_mptctl_ioctl:
> > 
> > Can you add MPTTEST added back in the switch/case?  It was 
> there before in
> > the register_ioctl32_conversion/unregister_ioctl32_conversion 's.
> 
> New patch with this changed. 
> 
> Convert mptctl to compat_ioctl. I also changed it to unlocked_ioctl
> while I was on it.
> 
> Signed-off-by: Andi Kleen <ak@muc.de>
> 
