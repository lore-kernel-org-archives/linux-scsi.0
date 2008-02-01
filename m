From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 01 Feb 2008 06:36:51 -0800
Message-ID: <1201876611.11265.296.camel@haakon2.linux-iscsi.org>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
	 <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010304p304614e9p78b0aca43b24246@mail.gmail.com>
	 <1201867517.11265.294.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010525r2e371286qb954db1fad88ff24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:46169 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753171AbYBAOhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 09:37:19 -0500
In-Reply-To: <e2e108260802010525r2e371286qb954db1fad88ff24@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, Roland Dreier <rdreier@cisco.com>, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Mike Mazarick <mazarick@bellsouth.net>

On Fri, 2008-02-01 at 14:25 +0100, Bart Van Assche wrote:
> On Feb 1, 2008 1:05 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> >
> > All of the kernel and C userspace code is open source and available from
> > linux-iscsi.org and licensed under the GPL.
> 
> I found a statement on a web page that the ERL2 implementation is not
> included in the GPL version (http://zaal.org/iscsi/index.html). The
> above implies that this statement is incorrect. Tomo, are you the
> maintainer of this web page ?
> 

This was mentioned in the context of the Core-iSCSI Initiator module.

> I'll try to measure the performance of the LIO Target Stack on the
> same setup on which I ran the other performance tests.
> 

Great!

--nab


