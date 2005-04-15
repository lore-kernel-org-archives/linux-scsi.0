From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Question about scsi_device_online() usage in mptscsih
Date: Fri, 15 Apr 2005 11:41:21 -0500
Message-ID: <1113583281.5009.25.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01F7CD79@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18364 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261855AbVDOQlh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 12:41:37 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C01F7CD79@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Fri, 2005-04-15 at 10:11 -0600, Moore, Eric Dean wrote:
> Thus I think its safe to say, we can remove the 
> scsi_device_online from mptscsih_flush_running_cmds.
> Right??

Yes, as long as you now tear down all the outstanding commands while the
error handler is executing, you should be safe from this condition.

James


