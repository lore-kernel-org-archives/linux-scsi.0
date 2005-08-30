From: tony.luck@intel.com
Subject: RE: As of 2.6.13-rc1 Fusion-MPT very slow
Date: Tue, 30 Aug 2005 14:49:39 -0700
Message-ID: <200508302149.j7ULndxS013113@agluck-lia64.sc.intel.com>
References: <91888D455306F94EBD4D168954A9457C037B0557@nacos172.co.lsil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr23.intel.com ([143.183.121.15]:61586 "EHLO
	scsfmr003.sc.intel.com") by vger.kernel.org with ESMTP
	id S932486AbVH3Vt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 17:49:58 -0400
In-reply-to: <200508301528.j7UFS0J2009272@agluck-lia64.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ia64@vger.kernel.org

> This is alive and well in 2.6.13 (final) on ia64.

Or perhaps not.  When I went into the machine room to take
a look at this machine, I found that the disk drive in
question was making some very bad noises.  A few minutes
later it stopped responding at all.

Putting in a new drive, I see a consistent 51 MB/s on /dev/sdb

Sorry for the noise.

-Tony
