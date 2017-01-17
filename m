From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol dependency
Date: Tue, 17 Jan 2017 11:44:44 -0600
Message-ID: <201701171744.v0HHiiSB029119@wind.enjellic.com>
References: <hch@infradead.org>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:55446 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbdAQSpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 13:45:41 -0500
In-Reply-To: Christoph Hellwig <hch@infradead.org>
       "Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol dependency" (Dec 16, 12:17am)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Tran, Quinn" <Quinn.Tran@cavium.com>
Cc: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Dec 16, 12:17am, Christoph Hellwig wrote:
} Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol

Good morning, I hope the week is going well for everyone.

Really late to this thread but am just getting caught d up after the
holidays and putting out fires.

> On Thu, Dec 15, 2016 at 08:50:39PM +0000, Tran, Quinn wrote:
>
> > Christoph, Qlogic was asked to support other Target Stack (SC ST)
> > using the same qla2xxx.ko upstream driver.  I had mentioned this
> > during the last 2015 LSF get together.  Hopefully, that gives a
> > better context.  The understanding that came away was Qlogic do
> > what is needed to provide this support without creating any dead
> > code.

> Right.  And what you're doing here is to create tons of pointless
> and dead code.  If you can support something else without clearly
> making the in-kernel version worse it's all fine.  This patch on the
> other hand is complete crap and totally unacceptable in this form.

It would be helpful to get an architectural overview of how Qlogic is
proposing to interface SCST to the in-kernel Qlogic target driver
code.  Are you going to follow a model of having an analogue of
tcm_qla2xxx for SCST?

We've been running for 3-4 years on the SCST target interface driver
we wrote to allow us to use the in-kernel Qlogic target driver code
with SCST.  We used the model of implementing the interface in
something we referred to as the scst_qla2xxx module and the model
seems solid.  There was a bit of an impedance mismatch but the changes
to the core kernel code were negligible.

Our code is being scheduled for an upgrade to 4.4 and to chase down
what have been reports about issues on 4 GBPS Qlogic cards.  Any
notion of a timeframe on the Cavium/Qlogic based solution?

Have a good day.

Dr. Greg

}-- End of excerpt from Christoph Hellwig

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Try to remove the color-problem by restarting your computer several
 times."
                                -- Microsoft-Internet Explorer
                                   README.TXT
