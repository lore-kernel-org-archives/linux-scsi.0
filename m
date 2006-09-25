From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ultra320 drive detected as narrow SCSI by adapter
Date: Sun, 24 Sep 2006 22:32:14 -0500
Message-ID: <1159155135.3462.22.camel@mulgrave.il.steeleye.com>
References: <6478431.post@talk.nabble.com>
	 <1159147910.3462.16.camel@mulgrave.il.steeleye.com>
	 <6479563.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40616 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750907AbWIYDcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 23:32:18 -0400
In-Reply-To: <6479563.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Israel Mouton <lebanon87@myrealbox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-09-24 at 19:57 -0700, Israel Mouton wrote:
> I don't seem to have a "/sys/class/spi_transport/" directory.  When the
> system boots the LSI board detects it as a narrow.  I was wondering if it is
> perhaps possible to reconfigure it under Linux at all?

Erm, what kernel is this?  The generic transport class, which does allow
you to configure this type of thing has been present in the kernel since
2.6.16

James


