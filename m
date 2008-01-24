From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 15:41:35 +0300
Message-ID: <4798877F.9090702@vlnb.net>
References: <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<20080117174542.GC29650@osc.edu>
	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	<4795D4A7.5000105@vlnb.net>
	<e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
	<20080124070616.GA31633@porcupine.cita.utoronto.ca>
	<e2e108260801240236o2273be0bw24a2a61dcc781222@mail.gmail.com>
	<4798720E.4020802@vlnb.net>
	<20080124114027.GC26751@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080124114027.GC26751-Td5ZOp7sT3Xw02mFwxTg32+DJq1SqhBbsOSz5zK2v9k@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Robin Humble wrote:
> On Thu, Jan 24, 2008 at 02:10:06PM +0300, Vladislav Bolkhovitin wrote:
> 
>>>On Jan 24, 2008 8:06 AM, Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org> wrote:
>>>
>>>>how are write speeds with SCST SRP?
>>>>for some kernels and tests tgt writes at >2x the read speed.
>>
>>There is a fundamental difference between regular dd-like reads and writes: 
>>reads are sync, i.e. latency sensitive, but writes are async, i.e. latency 
>>insensitive. You should use O_DIRECT dd writes for the fair comparison.
> 
> I agree, although the vast majority of applications don't use O_DIRECT.

Sorry, it isn't about O_DIRECT usage. It's about latency bound or not 
workload.

> anwyay, the direct i/o results were in the email:
> 
>   direct i/o dd
>    write/read  800/751 MB/s
>      dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
>      dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct
> 
> I couldn't find a direct i/o option for lmdd.
> 
> cheers,
> robin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
