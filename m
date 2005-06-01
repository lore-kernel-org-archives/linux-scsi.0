From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Wed, 01 Jun 2005 16:00:47 -0500
Message-ID: <1117659647.5047.52.camel@mulgrave>
References: <Pine.LNX.4.44L0.0506011440090.5912-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:65168 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261238AbVFAVAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 17:00:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506011440090.5912-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-06-01 at 14:45 -0400, Alan Stern wrote:
> Has there been any more progress on this issue?

Well, the patch is in scsi-misc, if that's what you're asking.

> I spoke with J=F6rg Schilling (author of the cdrecord package, a wide=
ly-used
> sg client) and he said that failed operations should be retried
> automatically if the command had not gotten as far as being sent on t=
he
> bus -- e.g., if the host adapter driver's queue was full.  But if the
> command did get sent to the device then any subsequent failure should=
 be
> reflected back to the client with no retrys.

That's pretty much what we do now ... with the exception of QUEUE_FULL
and BUSY handling.  What's the actual problem you were discussing?

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
