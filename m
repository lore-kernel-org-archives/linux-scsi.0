From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 22:40:33 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404132232490.11576-100000@poirot.grange>
References: <200404132217.25388.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:32186 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263739AbUDMUlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 16:41:18 -0400
In-Reply-To: <200404132217.25388.info@roessner-net.com>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 13 Apr 2004, Christian Roessner wrote:

> great! Problem fixed. cdrecord -scanbus show my TEAC 512
> writer. /proc/scsi/tmscsim/5 shows sync-speed 5.0M. Fine!
>
> Can I remove the debugging statements?

Yes! Now you are allowed to remove all the debugging!:-) And the last
thing I would ask you to try - is a bit of stress-testing. Try burning
some CDs (ok, you can burn re-writables, although, they tend to be slower
than recordables), put some load in parallel, mount dome CDs, dd from them
(dd if=/dev/scd0 of=/dev/null), play some music from them. Do you have any
other SCSI devices you could connect to it? But, you know, AM53C974 is not
the most performant SCSI-controller:-) Actually, when I just completed
initial porting it to 2.6, I said, it would be nice to test it on some
HIGHMEM / 64bit platforms, and somebody replied, that, probably, nobody
would ever think of using this chip on such a system:-)

And, please post output of your /proc/scsi/scsi and /proc/scsi/tmscsim/...

Thanks for your help!
Guennadi
---
Guennadi Liakhovetski


