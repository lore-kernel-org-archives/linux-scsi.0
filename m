From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Wed, 17 Sep 2003 11:07:03 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309171103070.820-100000@ida.rowland.org>
References: <200309170651.PAA02272@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6916 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262726AbTIQPHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2003 11:07:05 -0400
In-Reply-To: <200309170651.PAA02272@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Wed, 17 Sep 2003, Tomita, Haruo wrote:

> Hi Alan,
> 
> Alan> The system sent commands, but the device didn't respond to them. 
> Alan> However, it's possible that this patch will help.
> Alan> Try it out and see what happens.
> 
> Using 2.4.22-bk15, 
> It was adapted in the following patche and I tested.

> The test was successful the 3rd day or more with this patch.
> However, it became the following errors.
> I think that no data was transferred from the drive, 
> and the command timed out and was aborted.
> Ejection will also be impossible if it will be in this state. 
> I recovered the error by the power supply OFF.

Looks like that patch didn't help.

I still think it's something wrong with your drive.  Even though it works 
okay under 2.6 and not under 2.4.

Sorry I can't help any more than that.

Alan Stern


