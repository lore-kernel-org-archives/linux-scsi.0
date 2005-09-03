From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.13-mm1: hangs during boot ...
Date: Fri, 2 Sep 2005 22:25:07 -0700
Message-ID: <20050902222507.64e3ee4e.akpm@osdl.org>
References: <F7DC2337C7631D4386A2DF6E8FB22B30047FA061@hdsmsx401.amr.corp.intel.com>
	<43192D89.50504@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161138AbVICF05@vger.kernel.org>
In-Reply-To: <43192D89.50504@bigpond.net.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Peter Williams <pwil3058@bigpond.net.au> wrote:
>
> Brown, Len wrote:
> >>>[  279.662960]  [<c02d5c74>] wait_for_completion+0xa4/0x110
> > 
> > 
> > possibly a missing interrupt?
> > 
> > 
> >>CONFIG_ACPI=y
> > 
> > 
> > any difference if booted with "acpi=off" or "acpi=noirq"?
> 
> Yes.  In both cases, the system appears to boot normally

OK, we can pass this ball over to the ACPI team.

> but I'm unable 
> to login or connect via ssh.  Also there's a "device not ready" message 
> after the scsi initialization which I don't normally see.  I've attached 
> the scsi initialization output.  The PF_NETLINK error messages after the 
> login prompt in this output are created whenever I try to log in or 
> connect via ssh.

Linus hit that too - it's an interaction between PAM and a modified netlink
error code.

Dave, where are we up to with the fix for that?
