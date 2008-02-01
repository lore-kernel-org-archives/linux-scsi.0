From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 01 Feb 2008 04:05:17 -0800
Message-ID: <1201867517.11265.294.camel@haakon2.linux-iscsi.org>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
	 <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010304p304614e9p78b0aca43b24246@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34577 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758095AbYBAMGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 07:06:30 -0500
In-Reply-To: <e2e108260802010304p304614e9p78b0aca43b24246@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Mike Mazarick <mazarick@bellsouth.net>

On Fri, 2008-02-01 at 12:04 +0100, Bart Van Assche wrote:
> On Feb 1, 2008 11:39 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> >
> > On Fri, 2008-02-01 at 09:11 +0100, Bart Van Assche wrote:
> > > On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > > >
> > > > The PyX storage engine supports a scatterlist linked list algorithm that
> > > > ...
> > >
> > > Which parts of the PyX source code are licensed under the GPL and
> > > which parts are closed source ? A Google query for PyX + iSCSI showed
> > > information about licensing deals. Licensing deals can only be closed
> > > for software that is not entirely licensed under the GPL.
> > >
> >
> > I was using the name PyX to give an historical context to the
> > discussion. ...
> 
> Regarding the PyX Target Code: I have found a link via which I can
> download a free 30-day demo. This means that a company is earning
> money via this target code and that the source code is not licensed
> under the GPL. This is fine, but it also means that today the PyX
> target code is not a candidate for inclusion in the Linux kernel, and
> that it is unlikely that all of the PyX target code (kernelspace +
> userspace) will be made available under GPL soon.
> 

All of the kernel and C userspace code is open source and available from
linux-iscsi.org and licensed under the GPL.  There is the BSD licensed
code from userspace (iSNS), as well as ISCSI and SCSI MIBs.  As for what
pieces of code will be going upstream (for kernel and/or userspace), LIO
Target state machines and SE algoritims are definately some of the best
examples of GPL code for production IP storage fabric and has gained
maturity from people and resources applied to it in a number of
respects.

The LIO stack presents a number of possible options to get the diverse
amount of hardware and software to work.  Completely dismissing the
available code is certainly a waste, and there are still significant
amounts of functionality related to real-time administration, RFC-3720
MC/S and ERL=2 and generic SE functionality OS storage subsystems that
only exist in LIO and our assoicated projects.  A one obvious example is
the LIO-VM project, which brings LIO active-active transport recovery
and other Linux storage functionality to Vmware and Qemu images that can
provide target mode IP storage fabric on x86 non-linux based hosts.  A
first of its kind in the Linux/iSCSI universe.  

Anyways, lets get back to the technical discussion.

--nab

> Bart Van Assche.
> 

