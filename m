From: Florian Mickler <florian@mickler.org>
Subject: Re: 3.2.x Regression for SAS Controller on Dell C6100
Date: Fri, 24 Feb 2012 00:35:59 +0100
Message-ID: <20120224003559.41dea166@schatten>
References: <20120131180949.GT29272@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120131180949.GT29272@MAIL.13thfloor.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[adding some cc's from that area ]
On Tue, 31 Jan 2012 19:09:49 +0100
Herbert Poetzl <herbert@13thfloor.at> wrote:

> 
> Greetings!
> 
> I'm seeing a regression on a Dell C6100 machine with
> 3.2.x kernels, where the second disk (in a raid setup)
> is not properly recogniced and so the raid drops into
> degraded mode
> 
> the same hardware works fine with 3.1.x kernels and
> older
> 
> attached the dmesg output of the bootup for a working
> and a failing kernel
> 
> thanks in advance,
> Herbert
> 
