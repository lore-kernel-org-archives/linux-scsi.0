From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 20:12:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718201243.B13712@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org> <20030718122304.A23013@infradead.org> <1058536002.5950.3.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:36868 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271785AbTGRS5t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 14:57:49 -0400
Content-Disposition: inline
In-Reply-To: <1058536002.5950.3.camel@laptop.fenrus.com>; from arjanv@redhat.com on Fri, Jul 18, 2003 at 03:46:42PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Fri, Jul 18, 2003 at 03:46:42PM +0200, Arjan van de Ven wrote:
> On Fri, 2003-07-18 at 13:23, Christoph Hellwig wrote:
> > =20
> >  - qla2x00_intr_handler should use spin_lock, not spin_lock_irqsave
>=20
> possibly correct; on x86 irq handlers run with interrupts enabled for
> example; just too dangerous to do this esp if error recovery and simi=
lar
> code calls this from process context as well (iirc a few places do)

Well, that's only true for SA_INTERRUPT.  But I missed that qla2xxx
sets this.  So drop =FEhat comment.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
