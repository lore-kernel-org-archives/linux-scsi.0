From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 1 Feb 2008 12:04:14 +0100
Message-ID: <e2e108260802010304p304614e9p78b0aca43b24246@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
	 <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:38042 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbYBALEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 06:04:16 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1417954wxd.4
        for <linux-scsi@vger.kernel.org>; Fri, 01 Feb 2008 03:04:15 -0800 (PST)
In-Reply-To: <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Mike Mazarick <mazarick@bellsouth.net>

On Feb 1, 2008 11:39 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
> On Fri, 2008-02-01 at 09:11 +0100, Bart Van Assche wrote:
> > On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > >
> > > The PyX storage engine supports a scatterlist linked list algorithm that
> > > ...
> >
> > Which parts of the PyX source code are licensed under the GPL and
> > which parts are closed source ? A Google query for PyX + iSCSI showed
> > information about licensing deals. Licensing deals can only be closed
> > for software that is not entirely licensed under the GPL.
> >
>
> I was using the name PyX to give an historical context to the
> discussion. ...

Regarding the PyX Target Code: I have found a link via which I can
download a free 30-day demo. This means that a company is earning
money via this target code and that the source code is not licensed
under the GPL. This is fine, but it also means that today the PyX
target code is not a candidate for inclusion in the Linux kernel, and
that it is unlikely that all of the PyX target code (kernelspace +
userspace) will be made available under GPL soon.

Bart Van Assche.
