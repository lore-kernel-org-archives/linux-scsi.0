From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [5/11]   qla2xxx: Small fixes
Date: Sun, 19 Dec 2004 13:04:31 -0600
Message-ID: <1103483071.6566.10.camel@mulgrave>
References: <20041209073638.GA22095@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62902 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261324AbULSTE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Dec 2004 14:04:57 -0500
In-Reply-To: <20041209073638.GA22095@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-12-08 at 23:36 -0800, Andrew Vasquez wrote:
> ChangeSet
>   1.2239 04/12/08 14:57:28 andrew.vasquez@qlogic.com +1 -0
[...]
>      o Interrogate only the relevant bits (peripheral
>        qualifier and device-type) of INQUIRY data.

Do you still need to do this?  I see it's done as part of the driver's
own lun discovery.  However, if you relied on the mid-layer lun
discovery protocols, you could set FCF_TAPE_PRESENT in slave_configure
based on sdev->type instead of doing your own inquiry.

James


