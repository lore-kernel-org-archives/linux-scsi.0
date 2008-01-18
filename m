From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Fri, 18 Jan 2008 11:30:47 +0100
Message-ID: <e2e108260801180230sb1bd6edj4cbe6cd99e2f030e@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<20080117174542.GC29650@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080117174542.GC29650-pxmRpbKlMIQ@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Pete Wyckoff <pw-pxmRpbKlMIQ@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, vst-d+Crzxg7Rs0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Jan 17, 2008 6:45 PM, Pete Wyckoff <pw-pxmRpbKlMIQ@public.gmane.org> wrote:
> There's nothing particularly stunning here.  Suspect Bart has
> configuration issues if not even IPoIB will do > 100 MB/s.

Regarding configuration issues: the systems I ran the test on probably
communicate via PCI-e x4 with the InfiniBand HCA's. With other systems
with identical software and with PCI-e x8 HCA's on the same InfiniBand
network I reach a throughput of 934 MB/s instead of 675 MB/s (PCI-e
x4). This is something I only found out today, otherwise I would have
run all tests on the systems with PCI-e x8 HCA's.

So the relative utilization of the InfiniBand network is as follows:
* STGT + iSER, PCI-e x4 HCA: 324/675 = 48% (measured myself)
* STGT + iSER, PCI-e x8 HCA: 550/934 = 59%
(http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf)
* SCST + SRP, PCI-e x4 HCA: 600/675 = 89% (measured myself)

Or: SCST uses the InfiniBand network much more effectively than STGT.

Bart.
