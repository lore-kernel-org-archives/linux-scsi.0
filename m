From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] inia100.c: pointer used before being set
Date: 13 Jan 2004 00:17:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073971028.5177.1.camel@mulgrave>
References: <20040112210754.582573ad.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:29850 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263593AbUAMFRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 00:17:13 -0500
In-Reply-To: <20040112210754.582573ad.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-01-13 at 00:07, Randy.Dunlap wrote:
> drivers/scsi/inia100.c:421: warning: `pHCB' might be used uninitialized in this function

I think I've got a different (and slightly more extensive) fix already
in the scsi-misc-2.7 tree:

ChangeSet@1.1474.69.1, 2004-01-05 22:03:53-06:00, hch@lst.de
  [PATCH] fix inia100 driver
  
  John W Fort helped me debugging the brown paperbag bugs, the patch
below
  makes it work.

James


