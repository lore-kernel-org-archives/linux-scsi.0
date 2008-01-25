From: "Filippos Papadopoulos" <psybases@gmail.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 25 Jan 2008 23:04:30 +0200
Message-ID: <9f00bd9d0801251304hbc9f498xfad3e73dc42d16ec@mail.gmail.com>
References: <1200070903.3286.28.camel@localhost.localdomain>
	 <9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	 <1200410166.9273.4.camel@localhost.localdomain>
	 <20080116145916A.fujita.tomonori@lab.ntt.co.jp>
	 <1200495471.3136.1.camel@localhost.localdomain>
	 <20080121222037.3d8b46a1@lxorguk.ukuu.org.uk>
	 <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
	 <1201279772.3119.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758310AbYAYVEp@vger.kernel.org>
In-Reply-To: <1201279772.3119.38.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/25/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
>
> Actually, I suspect your issues should be fixed by this patch:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e2d435ea4084022ab88efa74214accb45b1f9e92
>
> Could you download 2.6.24 and try it out to see if they are?
>
> Thanks,
>
> James
>


Well, 2.6.24 fixes the problem.
Thanks to all of you!
