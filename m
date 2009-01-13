From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] next-20090113 - scsi_debug fails with
	CONFIG_CRC_T10DIF=n
Date: Tue, 13 Jan 2009 11:51:24 -0600
Message-ID: <1231869084.4519.22.camel@localhost.localdomain>
References: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
	 <20090113130215.GD2364@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49406 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbZAMRv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 12:51:27 -0500
In-Reply-To: <20090113130215.GD2364@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, 2009-01-13 at 18:32 +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
>     next-20090113 kernel randconfig fails with
> 
> ERROR: "crc_t10dif" [drivers/scsi/scsi_debug.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> Impact: Fix the dependency of scsi_debug on crc-t10dif library
> 
> scsi_debug calls the functions exported by crc-t10dif library,
> adding dependency to select CONFIG_CRC_T10DIF
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Already spotted by randy:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=37b1261d045f0b0be09fa1d51efac726385da105

James


