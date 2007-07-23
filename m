From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/2] 2.6.23-rc1: known regressions
Date: Mon, 23 Jul 2007 11:47:34 +0200
Message-ID: <46A47936.1090606__22808.2321853892$1185184272$gmane$org@googlemail.com>
References: <46A477AF.4000309@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760901AbXGWJul@vger.kernel.org>
In-Reply-To: <46A477AF.4000309@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>, Tilman Schmidt <tilman@imap.cc>, linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Horms <horms@verge.net.au>, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             4
Linus Torvalds                         4
Adrian Bunk                            3
Andrew Morton                          3
Jens Axboe                             3
Al Viro                                2
David Woodhouse                        2
Hugh Dickins                           2
Tejun Heo                              2



SCSI

Subject         : lpfc_sli.c: off-by-10
References      : http://lkml.org/lkml/2007/7/22/284
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Virtualization

Subject         : 2.6.22-git17 boot failure (XEN)
References      : http://lkml.org/lkml/2007/7/22/266
Last known good : ?
Submitter       : Tilman Schmidt <tilman@imap.cc>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : drivers/net/xen-netfront.c: bogus code
References      : http://lkml.org/lkml/2007/7/22/256
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
Status          : unknown



IA64

Subject         : Regression in serial console on ia64 after 2.6.22
References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
Last known good : ?
Submitter       : Horms <horms@verge.net.au>
Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
                  commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
Handled-By      : ?
Status          : unknown



Sparc64

Subject         : "build-id" changes break sparc64
References      : http://lkml.org/lkml/2007/7/22/38
Last known good : ?
Submitter       : David Miller <davem@davemloft.net>
Caused-By       : Roland McGrath <roland@redhat.com>
                  commit 18991197b4b588255ccabf472ebc84db7b66a19c
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
