From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 12:40:05 -0400
Message-ID: <42823565.9000806@adaptec.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33943 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261186AbVEKQkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 12:40:12 -0400
In-Reply-To: <20050510225831.GA4181@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 05/10/05 18:58, Patrick Mansfield wrote:
> As you say, what you really want is the correct result going back to the
> user, not the result of the TUR.
> 
> So save and restore the result in scsi_eh_tur, and also in scsi_eh_try_stu.
> The request sense one already saves and restores it.

I think he even wants the stronger condition -- after the command is reclaimed
from the LLDD, just send back the result to the application client.  And let
the application client decide whether they want to send TUR or something else.

	Luben
 
