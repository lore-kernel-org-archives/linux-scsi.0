From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Problem Adding Transport Class support to fusion
Date: Tue, 31 May 2005 11:39:10 -0500
Message-ID: <1117557550.4952.8.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C028C57FA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60650 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261961AbVEaQjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 12:39:14 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C028C57FA@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-05-31 at 10:25 -0600, Moore, Eric Dean wrote:
> I suspect your using dated firmware. Try /proc/mpt/summary,
> and check FwRev.

Yes, that was it: the fw revision was 1.0.4.0

Updating to 1.3.39.0 allowed me to get at Page 0.

Are there many cards in the field like this?

> Also, have you remembered our cards support RAID?  We kick
> of DV when a drive is replaced failed drive in a mirror. That
> is kicked off when fw sends ASYC event saying that the
> driver must to DV on that hidden phys disk.

Yes, we had a non-attachment scheme that Christoph suggested for the
components of the RAID devices.

> FYI - I'm getting ready to post SAS support for split drivers design.  
> I prefer that we push out generic DV support after we get the 
> SAS updates in, and some other bits of FC transport support 
> that have been waiting in the wings for several months.

Well, this is more driven by me ... I need to get the generic DV working
on u320, and the 1030 is the only u320 SCSI card I have to try it with.

Thanks,

James


