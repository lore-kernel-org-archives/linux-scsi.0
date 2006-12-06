From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 16:46:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612061645280.5127-100000@iolanthe.rowland.org>
References: <4577374B.9000204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43049 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S937680AbWLFVqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 16:46:46 -0500
In-Reply-To: <4577374B.9000204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 6 Dec 2006, Mike Christie wrote:

> Alternatively, if we do start not checking values like max sectors and
> send requests down to the drivers, the block layer mapping functions can
> be modified to not check certain values and LLDs/scsi-ml can return
> these BLKERR values all the way up to sg/bsg/scsi_ioctl.c for values
> that they need to check.

I bet in many cases the LLD depends on the higher layers to filter out 
transfers that are too large.  Duplicating all those tests in all the LLDs 
seems like a waste.

Alan Stern

