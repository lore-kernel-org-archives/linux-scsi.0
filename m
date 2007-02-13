From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work
	with LSI MegaRAID i4 since release 2.00.4
Date: Tue, 13 Feb 2007 11:59:17 -0600
Message-ID: <1171389557.3382.34.camel@mulgrave.il.steeleye.com>
References: <20070213092920.f0bafea0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59917 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXBMR7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 12:59:23 -0500
In-Reply-To: <20070213092920.f0bafea0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, rico@ricospirit.net

On Tue, 2007-02-13 at 09:29 -0800, Andrew Morton wrote:
> Subject: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work with LSI MegaRAID i4 since release 2.00.4

This is by design ... the i4 is now supported by the new megaraid_mbox
driver.  Please retry with that driver.

James


