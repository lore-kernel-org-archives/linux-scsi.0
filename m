From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: adaptec aar1210 serial ata and 2.6.0
Date: Mon, 15 Dec 2003 15:02:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1729770000.1071525777@aslan.btc.adaptec.com>
References: <074a01c3bd5f$a42fba80$7301a8c0@internal.kbs.net.au>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <074a01c3bd5f$a42fba80$7301a8c0@internal.kbs.net.au>
Content-Disposition: inline
To: Paul <paul@kbs.net.au>, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Hi All,
> 
> I am trying to get an adaptec 1210 serial ata raid controller working under
> 2.6.0. I've also tried 2.4.23
> I've found a patch for 2.6.0 by Mark Haverkamp at
> http://marc.theaimsgroup.com/?l=linux-scsi&m=10663501617378&w=2 and also a
> patch (for 2.4.22) by someone else (not sure who) which just resulted in
> lots of "lost interrupt" errors at bootup and it took around 30 minutes to
> boot.

The Adaptec BIOS masks interrups on the card.  You can re-enable interrupts
by clearing bits 6 & 7 at PCI configuration space address 0x8a.

--
Justin

