From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/7] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Sun, 27 Mar 2005 09:04:17 -0600
Message-ID: <1111935857.5567.17.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01B70565@nacos172.co.lsil.com>
	 <1111809137.5541.7.camel@mulgrave>  <20050327091630.GA938785@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:37313 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261691AbVC0PE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2005 10:04:27 -0500
In-Reply-To: <20050327091630.GA938785@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-03-27 at 01:16 -0800, Jeremy Higdon wrote:
> James, actually this queue depth code predates your change_queue_depth
> API.  I don't think it was ever converted to the new API.

Erk, you're right.  My todo list says I'm only waiting on 3ware patches
for all the conversions to be complete, but I think I missed auditing
fusion because it's not in the scsi directory...OK I'll do it after we
get the driver split sorted out.

James


