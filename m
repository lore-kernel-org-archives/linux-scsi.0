From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 14:58:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067551081.1138.7.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
	 <1067541899.1141.4.camel@ronald.kuetemeier.com>
	 <20031030134850.A9076@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:8710 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S262940AbTJ3V7W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 16:59:22 -0500
In-Reply-To: <20031030134850.A9076@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, 2003-10-30 at 14:48, Patrick Mansfield wrote:
> On Thu, Oct 30, 2003 at 12:25:00PM -0700, Ronald Kuetemeier wrote:
> > Sorry Patrick,
> > didn't work.
> > 
> > Applied patch (compile ...)
> > reboot no 3f
> > mount camera.
> > file: err-pat-scsi-1.patch_messages.txt
> > Ronald
> 
> Ronald -
> 
> Does the camera work OK on 2.4?
> 
Yeap, no problem.

> Can you hack the base 2.6 so the len is 255, and configure or modify to
> that it uses only page 3f so it closely matches what 2.4 sends, and see
> what happens?
> 
Sorry has to wait until next week. 

Ronald

> I don't think I screwed up the write check change, but that is possible.
> 
> -- Patrick Mansfield
> 

