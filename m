From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 21 Sep 2007 15:40:02 -0500
Message-ID: <1190407202.3333.55.camel@localhost.localdomain>
References: <BC382691D59EC94C8E57543C47EF8ED55B20E8@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55717 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752400AbXIUUkJ (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 21 Sep 2007 16:40:09 -0400
In-Reply-To: <BC382691D59EC94C8E57543C47EF8ED55B20E8@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: dougg@torque.net, Linux-scsi@vger.kernel.org

On Fri, 2007-09-21 at 11:53 -0700, Wu, Gilbert wrote:
>    I can reproduce the problem on my machine. Most likely, the Sequencer
> (Firmware) has bug on handling ATA output register for ATAPI device. I
> am still working on this issue with Sequencer engineer.

But, since you already vet the commands we can simply work around this
by not asking for the ATA output register on packet commands (i.e. just
add ATA_CMD_PACKET to the is_ata_rw_command() switch statement.

James


