From: Guennadi Liakhovetski <gl@dsa-ac.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Thu, 20 Nov 2003 12:37:51 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0311201234090.2153-100000@pcgl.dsa-ac.de>
References: <20031119153437.GA2115@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dsa-ac.de ([62.112.80.99]:11794 "EHLO k2.dsa-ac.de")
	by vger.kernel.org with ESMTP id S261773AbTKTLh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 06:37:56 -0500
In-Reply-To: <20031119153437.GA2115@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org

Hi

Tests yesterday showed, DMA-buffers are always empty (on receiving),
I printed out the first 32 bytes of the buffer on each interrupt, and it
is either all 0, or all 0x5a (or was it 0xa5?), or first 8 bytes 0, then
0x5a... So, either DMA isn't set up properly, or we are handling the wrong
buffer somewhere... Because, AFAIU, the chip receives commands from the
host correctly, according to the status-register readings...

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany

