From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add iSCSI session creation sysfs attributes
Date: Mon, 24 Jan 2005 09:34:00 -0600
Message-ID: <1106580841.5513.10.camel@mulgrave>
References: <41F4D072.5040800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61889 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261283AbVAXPeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 10:34:13 -0500
In-Reply-To: <41F4D072.5040800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-24 at 02:39 -0800, Mike Christie wrote:
> The attached patch built against scsi-misc-2.6 moves the
> target iSCSI attributes to a new structure representing
> a iSCSI session. The reason for doing this is to
> create a interface that allows the Sourceforge iSCSI driver
> to create and setup a session through sysfs (no more
> IOCTL at all in our driver), display session info, and at the same
> time share code and use the same interface HW iSCSI drivers would
> use.

This no longer applies to the iscsi transport class because I converted
it over to the generic framework.  Could you look at the code in

bk://linux-scsi.bkbits.net/scsi-rc-fixes-2.6 (or the patch on
www.parisc-linux.org/~jejb/scsi_diffs)

and reroll your patch against that?

Thanks,

James


