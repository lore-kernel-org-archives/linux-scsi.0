From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Fri, 28 Nov 2003 21:25:35 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311282118550.528-100000@poirot.grange>
References: <3FC6A7B0.3050401@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:45217 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263435AbTK1Ucu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 15:32:50 -0500
In-Reply-To: <3FC6A7B0.3050401@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>

Further to your tests, Thorsten: just tried cdecord v. 2.00.3 under 2.4.21
and (the same command) under 2.6.0-test7. Worked under 2.4, failed under
2.6. However, I tried it with an ATAPI CDRW, but still, it indicates, that
cdrecord is still not quite functional under 2.6. I did get some error
messages under 2.4:

Error: Illegal request -- (Sense key=0x05)

which, presumably, means some unsupported command, but still it worked. I
should look through LKML archives regarding cdrecord under 2.6, or anybody
can give a short info?

Guennadi
---
Guennadi Liakhovetski


