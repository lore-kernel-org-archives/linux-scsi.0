From: Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: 3.2.x Regression for SAS Controller on Dell C6100
Date: Fri, 24 Feb 2012 04:37:42 +0100
Message-ID: <20120224033742.GP29141@MAIL.13thfloor.at>
References: <20120131180949.GT29272@MAIL.13thfloor.at> <20120224003559.41dea166@schatten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120224003559.41dea166@schatten>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Mickler <florian@mickler.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2012 at 12:35:59AM +0100, Florian Mickler wrote:
> [adding some cc's from that area ]
> On Tue, 31 Jan 2012 19:09:49 +0100
> Herbert Poetzl <herbert@13thfloor.at> wrote:

>> Greetings!

>> I'm seeing a regression on a Dell C6100 machine with
>> 3.2.x kernels, where the second disk (in a raid setup)
>> is not properly recogniced and so the raid drops into
>> degraded mode

Just retested with 3.2.7 and 3.3-rc4 and it seems that
this regression got fixed somewhere between 3.2.2 and
3.2.7 ...

if there is interest, I can narrow it down to a specific
version change, just drop me a message ...

will do some more testing in the meantime.

HTH,
Herbert

>> the same hardware works fine with 3.1.x kernels and
>> older

>> attached the dmesg output of the bootup for a working
>> and a failing kernel

>> thanks in advance,
>> Herbert
