From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aacraid driver update
Date: Wed, 01 Apr 2009 14:32:02 +0000
Message-ID: <1238596322.3318.18.camel@mulgrave.int.hansenpartnership.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F40204F4B736@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50375 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957AbZDAOcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 10:32:07 -0400
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40204F4B736@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Wed, 2009-04-01 at 07:16 -0700, Leubner, Achim wrote:
> I want to send out a required aacraid driver update from version 1.1.5-2456 to 1.1.5-2461 as a patch against the latest scsi-misc-2.6 kernel (2.6.29-rc7). It includes the following changes:
> - set aac_cache=2 as default value to avoid performance problem (Novell bugzilla #469922)
> - Dell/PERC controller boot problem fixed (RedHat bugzilla #457552)
> - WWN flag added to fix SLES10 SP1/SP2 drive detection problems
> - 64-bit support changes
> - DECLARE_PCI_DEVICE_TABLE macro added
> - controller type changes

It would be really nice if, in future, you could send separate patches
for each of these totally separate fixes.  The reason is bisection ...
if one of them ends up causing a problem, we'll be able to tell which
one if they're separate.  Plus, it makes reviewing easier since it's
clear which change belongs to which fix.

Thanks,

James


