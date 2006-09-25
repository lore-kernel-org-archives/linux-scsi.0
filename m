From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: mainline aic94xx firmware woes
Date: Mon, 25 Sep 2006 17:07:30 +0300
Message-ID: <20060925140730.GO6374@rhun.haifa.ibm.com>
References: <20060925101124.GH6374@rhun.haifa.ibm.com> <20060925113042.GA18946@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:12440 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751562AbWIYOHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 10:07:33 -0400
Content-Disposition: inline
In-Reply-To: <20060925113042.GA18946@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>

On Mon, Sep 25, 2006 at 01:30:42PM +0200, Olaf Hering wrote:
> On Mon, Sep 25, Muli Ben-Yehuda wrote:
> 
> > The recently merged aic94xx in mainline requires external firmware
> > support. This, in turn, necessitates an initrd/initramfs environment
> > that includes firmware support to load the firmware. Will a patch to
> > optionally include the firmware inline in the kernel and thus not
> > having to use an initramfs be acceptable?
> 
> initramfs is always in use. Wether you pass in an additional image via
> the bootloader is up to you.
> Adding the firmware and required tools to your vmlinux binary is trivial
> with CONFIG_INITRAMFS_SOURCE="/some/file"

Thanks, I'll look into this.

Cheers,
Muli
