From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 17:00:03 -0600
Message-ID: <1201302003.3119.81.camel@localhost.localdomain>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41220 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760165AbYAYXAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 18:00:12 -0500
In-Reply-To: <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

On Sat, 2008-01-26 at 00:43 +0800, Ke Wei wrote:
> The attached is Marvell 6440 SAS/SATA driver. I will try to send email
> by git-send-email.
> 
> Changelog :
> Merged from Jeff's branch to James's branch.
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>

A compile test of this seems to show some problems:

drivers/scsi/mvsas.c:2126: warning: 'mvs_read_port_irq_mask' defined but not used
drivers/scsi/mvsas.c:796: warning: 'mvs_hba_interrupt_enable' defined but not used
drivers/scsi/mvsas.c:1349: warning: 'mvs_free_reg_set' defined but not used

The lack of interrupt enable looks potentially fatal...except that you
have an open coded interrupt enable in mvs_hw_init().

James


