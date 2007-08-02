From: Horms <horms@verge.net.au>
Subject: Re: [2/2] 2.6.23-rc1: known regressions
Date: Thu, 2 Aug 2007 11:09:47 +0900
Message-ID: <20070802020947.GD19198@verge.net.au>
References: <46A477AF.4000309@googlemail.com> <46A47936.1090606@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A47936.1090606@googlemail.com>
Sender: linux-ia64-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>, Tilman Schmidt <tilman@imap.cc>, linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> IA64
> 
> Subject         : Regression in serial console on ia64 after 2.6.22
> References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
> Last known good : ?
> Submitter       : Horms <horms@verge.net.au>
> Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
>                   commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
> Handled-By      : ?
> Status          : unknown

This was fixed by ensuring that machvex is set up before the
serial console

a07ee86205808d36973440e68c7277f9ed63b87f in Linus' tree

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

