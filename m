From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] Re: tmscsim broken on amd64 with 2.6.5?
Date: Thu, 15 Apr 2004 20:07:26 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404152001320.2512-100000@poirot.grange>
References: <200404151805.18505.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:48599 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263151AbUDOSHd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 14:07:33 -0400
In-Reply-To: <200404151805.18505.info@roessner-net.com>
List-Id: linux-scsi@vger.kernel.org
To: Roessner Christian <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, 15 Apr 2004, Roessner Christian wrote:

> today I have patched a fresh vanilla-2.6.5 with your code. I changed some
> lines (Do you use 2.6.3?).

Ohh, ok:-) If you diff the 2 patches, you'll see, that the only difference
is directory names:-) I did re-generate it against 2.6.5, it's just that I
forgot to update directory-names. So, if you apply it with -p1, it doesn't
really matter, although, I must confess, it is a bit confusing:-)

> I have burned CDs and did parallel reading with cp and two instances of dd=...
>
> I tested a CD with sector errors and one without errors. The code seems to be
> stable.

Good! James, could we get it into the mainline?

Thanks
Guennadi
---
Guennadi Liakhovetski



