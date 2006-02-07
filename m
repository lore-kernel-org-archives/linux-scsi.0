From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 7 Feb 2006 09:53:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602070952410.5164-100000@iolanthe.rowland.org>
References: <43E7D3DB.8060303@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:14041 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965113AbWBGOxw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 09:53:52 -0500
In-Reply-To: <43E7D3DB.8060303@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 6 Feb 2006, Brian King wrote:

> Alan Stern wrote:
> > Some protocols (like USB UFI) or devices that don't adhere to the SCSI
> > standard may indicate a nonexistent LUN by returning INQUIRY information
> > with Peripheral Device Type set to 0x1f (unknown or none) and Peripheral
> > Qualifier set to 0 instead of 3 as the spec requires.  This patch (as650)
> > causes PDT = 0x1f to be recognized as no LUN present regardless of the
> > qualifier value, if the SCSI level is equal to 0.
> 
> This patch will break the ipr driver. The ipr adapter firmware reports a
> logical scsi device which is used for RAID configuration. It reports
> a Peripheral Device Type of 0x1f and a scsi level of 0, since it does
> not claim compliance with any scsi level. 

I was afraid that might happen.  Okay, forget the patch.

How come you didn't mention the ipr driver before when I first raised the 
possibility of making this change?

Alan Stern

