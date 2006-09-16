From: Olaf Hering <olaf@aepfle.de>
Subject: Re: Linux 2.6.18-rc6
Date: Sat, 16 Sep 2006 10:44:34 +0200
Message-ID: <20060916084434.GA5161@aepfle.de>
References: <Pine.LNX.4.64.0609031939100.27779@g5.osdl.org> <20060905122656.GA3650@aepfle.de> <1157490066.3463.73.camel@mulgrave.il.steeleye.com> <20060906110147.GA12101@aepfle.de> <1157551480.3469.8.camel@mulgrave.il.steeleye.com> <20060907091517.GA21728@aepfle.de> <1157637874.3462.8.camel@mulgrave.il.steeleye.com> <1158378424.2661.150.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964804AbWIPIou@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1158378424.2661.150.camel@fc6.xsintricity.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 15, Doug Ledford wrote:

> Sorry for my belated response, but this usually happens when you access
> an aic chipset too soon after a chip reset.  Try putting a delay before
> whatever access is causing this to see if it make s difference.  Common
> problems include after a chip reset, touching any register will cause
> the card to reset, etc.

I put a ssleep(1) before the ahc_inb(ahc, SBLKCTL);
Does not help. Is it possible that the card loses some of its features
during reset and something needs to be done to reenable them?
