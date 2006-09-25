From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ultra320 drive detected as narrow SCSI by adapter
Date: Sun, 24 Sep 2006 20:31:49 -0500
Message-ID: <1159147910.3462.16.camel@mulgrave.il.steeleye.com>
References: <6478431.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52389 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932203AbWIYBbx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 21:31:53 -0400
In-Reply-To: <6478431.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Israel Mouton <lebanon87@myrealbox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-09-24 at 17:20 -0700, Israel Mouton wrote:
> scsi0 : ioc0: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=9
>   Vendor: MAXTOR    Model: ATLAS10K5_147SCA  Rev: JNX0
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)

It's not doing domain validation, which configures the device ... that
could be a driver bug, but I know of no outstanding problems in that
area.

You can try to re-trigger it with 

echo 1 > /sys/class/spi_transport/target0:0:0/revalidate

and see what happens?

Thanks,

James


