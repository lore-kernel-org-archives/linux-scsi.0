From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 30 Oct 2003 11:15:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067537753.6411.71.camel@pathost1.iomegacorp.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:23244 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262736AbTJ3SQK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 13:16:10 -0500
In-Reply-To: <20031030100501.A7250@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> Here's a patch, per Pat LaVarre's suggestion,

Wow.  Thanks for finding the time to write out that idea you heard in
full.

In my own copious free time, I was hoping to survey uses of scsi_lib.c
__scsi_mode_sense to see if inside drivers/scsi/ we could settle on a
standard way of calculating len.

For example, if we knew that the len passed to __scsi_mode_sense was
calculated for an op x1A MODE_SENSE, then always when we chose to
substitute op x5A MODE_SENSE_10, we always could add four bytes to
account for the eight byte header replacing the four byte header.  Or
vice versa.

I'm curious to know if that to-my-eye-cleaner code would produce
precisely the same actual resulting cdb's and expected data lengths as
the patch we now have proposed.

Pat LaVarre

[[[ P.S. I'm almost, but not quite, as lazy as I now appear.  In my
newbie ignorance my Linux spontaneously ceased to boot yesterday for
reasons I was unable to fathom.  Since then I've been reinstalling from
scratch, and just now I'm lost somewhere in a newbie rpm hell where I
can `make xconfig` 2.4 kernels but not 2.6 kernels. ]]]


