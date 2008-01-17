From: Erez Zilber <erezz-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 16:46:22 +0200
Message-ID: <478F6A3E.6020301@Voltaire.COM>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<478F64A0.6020201@Voltaire.COM> <478F6708.30604@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <478F6708.30604-d+Crzxg7Rs0@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


>> We didn't run any real performance test with tgt, so I don't have
>> numbers yet. I know that Pete got ~900 MB/sec by hacking sgp_dd, so all
>> data was read/written to the same block (so it was all done in the
>> cache). Pete - am I right?
>>
>> As already mentioned, he got that with IB SDR cards that are 10 Gb/sec
>> cards in theory (actual speed is ~900 MB/sec). With DDR cards (20
>> Gb/sec), you can get even more. I plan to test that in the near future.
>
> Are you writing about a maximum possible speed which he got, including
> multithreded tests with many outstanding commands or about speed he
> got  on single threaded reads with one outstanding command? This
> thread is about the second one.
>

As I said, we didn't run any performance tests on stgt yet.

Erez
