From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: 2.6.7 scsi regression
Date: 17 Jun 2004 22:03:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087527814.1795.101.camel@mulgrave>
References: <20040617194652.4f9acff1.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:29384 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264973AbUFRDDk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 23:03:40 -0400
In-Reply-To: <20040617194652.4f9acff1.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Phil Oester <kernel@linuxace.com>

On Thu, 2004-06-17 at 21:46, Andrew Morton wrote:
> Ideas?

Yes, I the fix is in scsi-misc-2.6:

ChangeSet@1.1767, 2004-06-15 12:48:08-05:00, jejb@mulgrave.(none)
  Fix endless loop in SCSI SPI transport class
  
  If the driver doesn't update the peroid, we go
  around forever.  The fix is to keep our old period
  unless the driver returns a greater one.
  
  Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

James


