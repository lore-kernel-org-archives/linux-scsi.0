From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Thu, 10 Dec 2009 20:25:23 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912102022460.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>  <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>  <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se> <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
  <alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se> <73e903670912041108o32c28af3q5a61e5a2e33edd0a@mail.gmail.com> <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 5 Dec 2009, Mikael Abrahamsson wrote:

> When removing this extra option, it compiles with vanilla 2.6.32 just 
> fine. I crashes the same way as the ubuntu kernel when hot-plugging a 
> disk as well (this time I did it without gdm/x running and it oopses, 
> but unfortunately the highest part of the oops scrolled off). It's 100% 
> reproducible anyway, so basically the controller is a no-go in 2.6.31.6 
> and 2.6.32 both vanilla and ubuntu versions, both without and including 
> the nov09 mvsas patch (at least the original version of the patch as 
> posted). Different failure scenarios though... With the stock kernel the 
> controller seems to get stuck in writing and nothing more happens but at 
> least the machine doesn't crash and burn like it does with the 
> mvsas-patch.

Would it make sense for me to log this problem in bugzilla? There seems to 
be a similar issue with equal hw:

<http://bugzilla.kernel.org/show_bug.cgi?id=14534>

did these fixes ever go upstream? Are they scheduled to go into the 
stable rebuilds of 2.6.32 ? The patches mentioned in there, are these the 
ones I already tried that didn't solve my problem?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
