From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 6061] scsi unknown opcode message
Date: Sun, 12 Feb 2006 18:37:52 -0600
Message-ID: <1139791072.3750.1.camel@mulgrave.il.steeleye.com>
References: <200602122300.k1CN0E9K027290@fire-2.osdl.org>
	 <20060212154305.455feca6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15024 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751503AbWBMAh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 19:37:57 -0500
In-Reply-To: <20060212154305.455feca6.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Sun, 2006-02-12 at 15:43 -0800, Andrew Morton wrote:
> scsi problem: this aic79xx machine emits "scsi: unknown opcode 0xfa"
> sometimes.

It's not a SCSI problem.  The warning is coming from
block/scsi_ioctl.c:verify_command()

And what it's saying is that the user send a SCSI command (using SG_IO)
with an opcode it couldn't classify (0xfa is a group 7 vendor specific
command).

James


