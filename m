From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] mpt fusion: Avoid racing when mptsas and mptcl
	module are loaded in parallel
Date: Fri, 08 Feb 2008 10:46:49 -0600
Message-ID: <1202489209.3102.36.camel@localhost.localdomain>
References: <20080208110540.GD20415@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57025 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143AbYBHQqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 11:46:54 -0500
In-Reply-To: <20080208110540.GD20415@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, 2008-02-08 at 16:35 +0530, Prakash, Sathya wrote:
> This patch sets the IOC pointer in drvrdata of pcidev before adding
> the IOC into the list of IOCs. Without this patch the driver oops when
> the mptsas and mptctl modules are loaded in parallel.

Much better, thanks.

Would I be correct in assuming that even though this email says [PATCH
3/3] there aren't two missing precursor patches?

James


