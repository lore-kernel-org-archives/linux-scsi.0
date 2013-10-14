From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Mon, 14 Oct 2013 08:29:50 -0700
Message-ID: <20131014152950.GA6625@infradead.org>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>
 <525BC836.2030306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3JNP36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 11:29:58 -0400
Content-Disposition: inline
In-Reply-To: <525BC836.2030306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Wangshen (C)" <peter.w@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Jinbo (Justin)" <jinbo@huawei.com>

On Mon, Oct 14, 2013 at 12:32:22PM +0200, Hannes Reinecke wrote:
> However, there are two other patchsets pending (EH Deadline and
> asynchronous command aborts), both of which have been tested
> thoroughly _and_ have acked-by from various other parties.
> None of these patchset had received any feedback from James
> Bottomley, let alone any indication if or when they'll be merged.
> 
> So I stopped sending further patchsets, sensing some communication
> breakdown on the line.

Maybe we'll need to start a common scsi staging tree for all patches
that have gotten a wide amount of reviews and are interesting to many
parties.  Thay way we have one common set of patches for the
distributions to pull from, and a tree to develop against where
dependencies between the patchsets exist.

