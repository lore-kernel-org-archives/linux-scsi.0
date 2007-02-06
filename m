From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devicedriver for new sequence firmware.
Date: Tue, 6 Feb 2007 11:02:34 -0800
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B0F59E7@aime2k302.adaptec.com>
References: <1170541723.3345.64.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:48227 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965284AbXBFTCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2007 14:02:43 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1170541723.3345.64.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

  We are investigating this issue here. We will update the status when
we can duplicate the problem here and root cause.

Thanks!
Gilbert


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Saturday, February 03, 2007 2:29 PM
To: Wu, Gilbert
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source
devicedriver for new sequence firmware.

On Tue, 2007-01-30 at 15:31 -0800, Wu, Gilbert wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source
device
> driver for new sequence firmware.

I put the patch, which seems fine, into scsi-misc-2.6; however, it looks
like the firmware isn't fine.  With the V28 firmware I get instability
on my directly attached SATA disk.  It begins about three minutes into a
small exercise of the filesystem on the disk as:

Feb  3 16:13:50 localhost kernel: sas: command 0xf7aca994, task
0x00000000, gone: EH_RESET_TIMER

and then times out commands and eventually flips ext3 into read only
mode because of the errors.

If I run the same tests with the V17/10c6 firmware, everything runs fine
and to completion.

James


