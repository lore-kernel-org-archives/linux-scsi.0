From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Sat, 16 Jun 2007 00:11:02 +0100
Message-ID: <20070616001102.3d2fa850@the-village.bc.nu>
References: <1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070615.141917.85409547.davem@davemloft.net>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: David Miller <davem@davemloft.net>
Cc: axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

> That sounds like a good idea for my virtual I/O case on
> Niagara too actually :-)

It was actually meant semi-seriously in that drivers/ata sits on top of
the abstract parts of drivers/scsi which James keeps asking for someone to
get split properly off and which would sort all these out.

> Another quirk I have to deal with is that under LDOMs you
> can export full disks and also just slices.  So I'll have
> to get down into the partition machinery to support that
> somehow.

If your slices don't fit the PC worldview you might want to look at
dmraid and just use device mapper to handle them. It is a lot more
flexible and we could actually bin all our partition code and use this
but for back compatibility.

Alan
