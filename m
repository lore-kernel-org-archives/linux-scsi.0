From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: Add VPD helper
Date: Sat, 10 Jan 2009 12:53:29 -0600
Message-ID: <1231613610.3642.42.camel@localhost.localdomain>
References: <1230747167-31677-1-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37550 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbZAJSxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 13:53:34 -0500
In-Reply-To: <1230747167-31677-1-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Wed, 2008-12-31 at 13:12 -0500, Matthew Wilcox wrote:
> Based on prior work by Martin Petersen and James Bottomley, this patch
> adds a generic helper for retrieving VPD pages from SCSI devices.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Could you run checkpatch on these before sending, please:

ERROR: trailing whitespace
#131: FILE: drivers/scsi/scsi.c:1035:
+^I/* Ask for all the pages supported by this device */ $

I've fixed it up manually this time.

James


