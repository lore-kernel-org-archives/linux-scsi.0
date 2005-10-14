From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Fri, 14 Oct 2005 15:53:35 +0200
Message-ID: <1129298016.2873.12.camel@laptopd505.fenrus.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
	 <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
	 <1129275031.2873.3.camel@laptopd505.fenrus.org>
	 <434FB4A4.2040904@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59629 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750869AbVJNSrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 14:47:33 -0400
In-Reply-To: <434FB4A4.2040904@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Fri, 2005-10-14 at 23:37 +1000, Douglas Gilbert wrote:

> Arjan,
> Apart from not being consulted beforehand, what precisely
> is objectionable in the above?

It allows people to make binary only linux modules (in so far binary
kernel modules are allowed at all, eg not that far, but still, this text
would give people the impression that it would be allowed and even
approved/OK to do so from this driver), or binary only <ANYTHING>
modules from this driver, including the bits I worked on.

 
> > Andrew: you can't do this. You just CANNOT change the license of code
> > you don't own fully without consent of ALL contributors.
> 
> Often wondered about that. Someone sends me a bug fix,
> I accept it, credit them and then at some later stage
> want to broaden the license on that code from GPL to
> BSD (say). Do I need the bug fixer's permission?

I think the lawyers will say "depends on the size of the contribution";
for a single one liner it's "probably not" although politeness certainly
would require it; for anything substantially bigger, you do need that.

(and "substantially" is obviously subject to interpretation, and that's
the bit where you need to talk to lawyers realistically if you want to
know the exact boundary)


