From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH] mptsas: fix dma alignment
Date: Tue, 08 Sep 2009 14:22:46 +0000
Message-ID: <1252419766.3990.47.camel@mulgrave.site>
References: <20090902010331.37889a2c@vitb-lp>
	 <0D1E8821739E724A86F4D16902CE275C1C8EAE0A19@inbmail01.lsi.com>
	 <20090907174538.67c7cedd@vitb-lp>
	 <0D1E8821739E724A86F4D16902CE275C1C8EAE0B11@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIHOWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 10:22:52 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8EAE0B11@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, "Moore, Eric" <Eric.Moore@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2009-09-08 at 13:49 +0530, Desai, Kashyap wrote:
> After seeing original commit from James, this patch looks OK to me.
> Please consider this patch as ACKed by me.

If you're sure it's a problem.  The reason for the original was that all
DMA engines (including the old LSI 1010) can transfer on word
boundaries.  I didn't realise the 1030 had regressed in terms of DMA
alignment requirements.

James


