From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: OOM Killer killing whole system
Date: Wed, 25 Jan 2006 23:20:42 +0100
Message-ID: <pan.2006.01.25.22.20.40.283831@smurf.noris.de>
References: <1137337516.11767.50.camel@localhost> <1137793685.11771.58.camel@localhost> <20060120145006.0a773262.akpm@osdl.org> <200601201819.58366.chase.venters@clientec.com> <20060120165031.7773d9c4.akpm@osdl.org> <1137806248.4122.11.camel@mulgrave> <1137814181.11771.70.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932171AbWAYWVL@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi, Anton Titov wrote:

> Just to mention, that 2.6.14.2 does not have this problem:

That's good, in that a couple of iterations with "git bisect" should
be able to pinpoint the bug.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
:hack on: vt. [very common] To {hack}; implies that the subject is some
   pre-existing hunk of code that one is evolving, as opposed to something
   one might {hack up}.
