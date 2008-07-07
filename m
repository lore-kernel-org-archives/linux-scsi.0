From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/4] scsi_get_vpd_page
Date: Mon, 07 Jul 2008 10:35:46 -0500
Message-ID: <1215444946.3274.24.camel@localhost.localdomain>
References: <20080623151712.GF4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48914 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbYGGPfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 11:35:48 -0400
In-Reply-To: <20080623151712.GF4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-06-23 at 09:17 -0600, Matthew Wilcox wrote:
> Based on prior work by Martin Petersen and James Bottomley, this patch
> adds a generic helper for retrieving VPD pages from SCSI devices within
> the kernel.

Could have done with running through checkpatch:

ERROR: trailing whitespace
#96: FILE: drivers/scsi/scsi.c:1055:
+^I/* Ask for all the pages supported by this device */ $

James


