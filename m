From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSI target drivers?
Date: Thu, 18 Oct 2007 08:26:06 +0900
Message-ID: <20071018082606H.fujita.tomonori@lab.ntt.co.jp>
References: <47161BEA.704@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:39599 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbXJQX3U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 19:29:20 -0400
In-Reply-To: <47161BEA.704@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Wed, 17 Oct 2007 10:27:54 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Where can one find patches/code that illustrates target mode support?

I think that the srp class and ibmvstgt (drivers/ibmvscsi/ibmvstgt)
are useful.

The fc class and qla2xxx are useful too but more complicated than
ibmvstgt:

- fc_transport: add target driver support

http://marc.info/?l=linux-scsi&m=118857984316539&w=2

- qla2xxx: add target mode support

http://marc.info/?l=linux-scsi&m=118857984513557&w=2


The former patch is in mainline and the latter has been reviewed by
Qlogic.


> Marvell 6440 ("mvsas") supports target mode for both SAS and SATA, and I 
> would like to prepare the driver as best I can for target mode.

Great! It would be really nice to have SAS target support.
