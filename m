From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Add compat_ioctl to mptctl
Date: Thu, 20 Jan 2005 18:24:25 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CEAAE15@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:25793 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262191AbVAUBZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 20:25:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thursday, January 20, 2005 2:38 AM, Andi Kleen wrote:
> 
> Sorry. I swear it compiled at one point, but some last minute
> changes must have broken it. Please try this version.
> 
> 
> Convert mptctl to compat_ioctl. I also changed it to unlocked_ioctl
> while I was on it.
> 
> Signed-off-by: Andi Kleen <ak@muc.de>
> 

This test compilies, and I have tested it today with both 32bit and 64bit
apps on x86_64.  Works fine.

One request is in compat_mptctl_ioctl:

Can you add MPTTEST added back in the switch/case?  It was there before in
the register_ioctl32_conversion/unregister_ioctl32_conversion 's.

Thankyou,
Eric Moore
