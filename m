From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: mainline aic94xx firmware woes
Date: Mon, 25 Sep 2006 13:11:24 +0300
Message-ID: <20060925101124.GH6374@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:29549 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750932AbWIYKL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 06:11:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>

Hi,

The recently merged aic94xx in mainline requires external firmware
support. This, in turn, necessitates an initrd/initramfs environment
that includes firmware support to load the firmware. Will a patch to
optionally include the firmware inline in the kernel and thus not
having to use an initramfs be acceptable?

Also, aic94xx does not compile unless FW_LOADER is set in .config due
to missing 'request_firmware'. What's the right thing to do here -
aic94xx selecting it, depending on it, or FW_LOADER providing empty
request_firmware() in case it's compiled out (the last one violates
the principle of least surprise IMHO).

Cheers,
Muli
