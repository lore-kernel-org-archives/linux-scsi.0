From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 12:24:39 -0500
Message-ID: <1120929879.5008.15.camel@mulgrave>
References: <200507091656.j69GuP5Y028863@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15747 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261626AbVGIRYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 13:24:43 -0400
In-Reply-To: <200507091656.j69GuP5Y028863@einhorn.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, bcollins@debian.org, arjan@infradead.org, rbrito@ime.usp.br

On Sat, 2005-07-09 at 18:56 +0200, Stefan Richter wrote:
> -- bad inquiry with TYPE_RBC patch --
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>   Vendor: ST316002  Model: 1A                Rev: 3.06
>   Type:   Unknown                            ANSI SCSI revision: 04

Could you get a copy of the device's sysfs type file when this happens?

should be under /sys/class/scsi_device/<dev>/device/type

Thanks,

James


