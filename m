From: Horms <horms@verge.net.au>
Subject: Re: [Fastboot] [RFC] [PATCH 2/2] kdump: cciss driver initialization?issue fix
Date: Tue, 27 Jun 2006 11:30:48 +0900
Message-ID: <20060627023048.GJ2956@verge.net.au>
References: <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com> <20060626090915.CA8333402A@koto.vergenet.net> <20060626134536.GB8985@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030611AbWF0Cmv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060626134536.GB8985@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, mike.miller@hp.com, "Zou, Nanhai" <nanhai.zou@intel.com>, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 26, 2006 at 09:45:36AM -0400, Vivek Goyal wrote:
> On Mon, Jun 26, 2006 at 06:09:15PM +0900, Horms wrote:
> > In article <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com> you wrote:
> > > 
> > > Not all pci busses support it but there is a standard pci bus reset bit
> > > in pci bridges.
> > > 
> > > I don't know if it would help but it might make sense to have a config
> > > option that can be used to mark drivers that are known to have problems,
> > > in these scenarios.
> > > 
> > > CONFIG_BRITTLE_INIT perhaps?
> > > 
> > > It would at least make it easier for people to see which drivers
> > > they don't want to use, and give people some incentive to fix things.
> > 
> > I believe that MPT Fusion could go on that list.
> > 
> > http://permalink.gmane.org/gmane.linux.ports.ia64/14451
> > 
> >
> 
> Above link does not give details of exact MPT fusion initialization 
> problems faced on IA64. I faced MPT fusion initialization issues on
> i386/x86_64 and posted a fix.
> 
> http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9bf0a28c9a24e2cee5deecf89d118254374c75ba
> 
> You might want to download and check.

Thanks, I wasn't aware of that. I'll see if that helps on ia64.

-- 
Horms                                           
H: http://www.vergenet.net/~horms/          W: http://www.valinux.co.jp/en/
