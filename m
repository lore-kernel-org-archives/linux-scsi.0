From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bug 3482] New: plugging/unplugging usb devices causes
	mm/slab.c kernel bug
Date: 29 Sep 2004 21:27:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096507642.2124.174.camel@mulgrave>
References: <20040929210241.55cf3d09.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29632 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267681AbUI3B1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 21:27:33 -0400
In-Reply-To: <20040929210241.55cf3d09.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Thu, 2004-09-30 at 00:02, Andrew Morton wrote:
> Is anyone else getting a bit bored of this bug?

The fix should be in the scsi-misc-2.6 tree (although I still haven't
had confirmation from anyone):

ChangeSet@1.2258, 2004-09-29 11:22:30-04:00, jejb@mulgrave.(none)
  Add refcounting to scsi command allocation
  

James


