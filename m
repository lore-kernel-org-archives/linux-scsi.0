From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Mon, 21 Jan 2008 15:07:40 +0300
Message-ID: <47948B0C.7020702@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	
	<478F246C.4040400@vlnb.net>	
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>	
	<20080117174542.GC29650@osc.edu> <479096D2.8090003@vlnb.net>
	<e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <e2e108260801200136g7f17b8a0g89a54cc1d73bbc34-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Jan 18, 2008 1:08 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
> 
>>[ ... ]
>>So, seems I understood your slides correctly: the more valuable data for
>>our SCST SRP vs STGT iSER comparison should be on page 26 for 1 command
>>read (~480MB/s, i.e. ~60% from Bart's result on the equivalent hardware).
> 
> 
> At least in my tests SCST performed significantly better than STGT.
> These tests were performed with the currently available
> implementations of SCST and STGT. Which performance improvements are
> possible for these projects (e.g. zero-copying), and by how much is it
> expected that these performance improvements will increase throughput
> and will decrease latency ?

Sure, zero-copying cache support is well possible for SCST and hopefully 
will be available soon. The performance (throughput) improvement will 
depend from used hardware and data access pattern, but the upper bound 
estimation can be made knowing memory copy throughput on your system 
(1.6GB/s according to your measurements). For 10Gbps link with 0.9GB/s 
wire speed it should be up to 30%, for 20Gbps link with wire speed 
1.5GB/s (PCI-E 8x limitation) - something up to 70-80%.

Vlad
