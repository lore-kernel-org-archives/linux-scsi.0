From: Grant Grundler <iod00d@hp.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Wed, 18 Jun 2003 13:52:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030618205242.GH23761@cup.hp.com>
References: <A5974D8E5F98D511BB910002A50A66470580D91A@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:34488 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S265526AbTFRUiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 16:38:46 -0400
Content-Disposition: inline
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D91A@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: Douglas Gilbert <dougg@torque.net>, Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jun 10, 2003 at 11:32:33AM -0700, Cress, Andrew R wrote:
> You can set the block descriptor as part of the mode page file using sgmode
> from
>   http://scsirastools.sourceforge.net

Andrew,
no - this won't work for many of the Seagate drives.
The "mask" for format mode page is mostly zeros.
See my blk512-linux.c at:
	ftp://gsyprf10.external.hp.com/pub/scsi/blk512

(older code is at .../blk512_old)

thanks,
grant
