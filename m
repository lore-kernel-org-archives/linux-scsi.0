From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 3/3] mpt fusion: Avoid racing when mptsas and mptclmodule are loaded in parallel
Date: Sat, 9 Feb 2008 00:49:54 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BEFB1C57@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52426 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbYBHQuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 11:50:10 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

James,
I tried to submit set of three patches, the other two patches are not
showing in the list yet, I don't know the reason, 
I have resent them again few minutes back.
Thanks
Sathya 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, February 08, 2008 10:17 PM
To: Prakash, Sathya
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: [PATCH 3/3] mpt fusion: Avoid racing when mptsas and
mptclmodule are loaded in parallel

On Fri, 2008-02-08 at 16:35 +0530, Prakash, Sathya wrote:
> This patch sets the IOC pointer in drvrdata of pcidev before adding 
> the IOC into the list of IOCs. Without this patch the driver oops when

> the mptsas and mptctl modules are loaded in parallel.

Much better, thanks.

Would I be correct in assuming that even though this email says [PATCH
3/3] there aren't two missing precursor patches?

James


