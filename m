From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Status of patch as168 (sysfs readonly max_sectors attribute)
Date: 15 Jan 2004 13:18:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074190688.1867.143.camel@mulgrave>
References: <Pine.LNX.4.44L0.0401151300560.965-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:23483 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265205AbUAOSSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 13:18:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401151300560.965-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2004-01-15 at 13:03, Alan Stern wrote:
> Does that mean you don't want to apply it and it should be done privately 
> within usb-storage?  Or has it already been applied without me realizing?

Sorry, I meant to comment on this.

The thing I really don't like is the fact that max_sectors is a block
attribute but it's being exported from SCSI, I didn't catch this until I
saw the patch.  This means it's should properly be exported at the block
level, not at the SCSI level.

James


