From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx status
Date: Mon, 10 Jul 2006 11:27:07 -0500
Message-ID: <1152548827.7275.20.camel@mulgrave.il.steeleye.com>
References: <1152376067.12020.26.camel@mulgrave.il.steeleye.com>
	 <20060710160915.GA30179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22428 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422682AbWGJQ1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 12:27:10 -0400
In-Reply-To: <20060710160915.GA30179@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Mon, 2006-07-10 at 09:09 -0700, Mike Anderson wrote:
> Currently I am running a loaned SATA drive with the patch below. It
> just
> generates the "Unidentified device type" type message when it detects
> a
> SATA device and appears in my configuration to not cause any bad
> things to
> happen.

That seems to cover the directly attached case, thanks.

What happens if the SATA device is remote over an expander using STP?
That seems to have a separate case in sas_ex_discover_end_dev.

Thanks,

James


