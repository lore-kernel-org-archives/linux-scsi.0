From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sym2: remove code to handle DMA_BIDIRECTION requests
Date: Thu, 15 Sep 2005 22:12:33 +1000
Message-ID: <43296531.5090709@torque.net>
References: <20050914134131.GA9700@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:21436 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751168AbVIOML5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:11:57 -0400
In-Reply-To: <20050914134131.GA9700@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> The upper layer doesn't send these down since 2.4.x (or 2.6 in
> practice), so no need to handle it.  Inline sym_setup_data_pointers
> into it's only caller so we can fail gracefully in the case we'd get
> one neverless.

Christoph,
I have no objection to this patch.

I would like to flag that at some stage in the
future the SCSI (or whatever it may be called)
subsystem will need to support true bidirectional
commands (there are a few of these in SBC-2 and
lots of them in OSD). To do it properly I think we
need two scatter gather lists, one for data out
(to the device) and one for data in (from the device).
The SBC-2 XDWRITEREAD command indicates that the data out
is done before the data in (from the device); I'm not
sure whether that ordering is always the case.

Doug Gilbert

