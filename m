From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] inia100.c: pointer used before being set
Date: Mon, 12 Jan 2004 21:30:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112213034.5fc5d1a6.rddunlap@osdl.org>
References: <20040112210754.582573ad.rddunlap@osdl.org>
	<1073971028.5177.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:30949 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263598AbUAMFc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 00:32:27 -0500
In-Reply-To: <1073971028.5177.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On 13 Jan 2004 00:17:07 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:

| On Tue, 2004-01-13 at 00:07, Randy.Dunlap wrote:
| > drivers/scsi/inia100.c:421: warning: `pHCB' might be used uninitialized in this function
| 
| I think I've got a different (and slightly more extensive) fix already
| in the scsi-misc-2.7 tree:
| 
| ChangeSet@1.1474.69.1, 2004-01-05 22:03:53-06:00, hch@lst.de
|   [PATCH] fix inia100 driver
|   
|   John W Fort helped me debugging the brown paperbag bugs, the patch
| below
|   makes it work.

OK, I looked for scsi-patch trees and just didn't look in one
named with "2.7" in it since I think that this should be fixed
before then.

--
~Randy
