From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym2 2.1.18k
Date: Tue, 14 Sep 2004 03:27:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3brg9k5c3.fsf@merlin.emma.line.org>
References: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk>
	<m38ybdlur2.fsf@merlin.emma.line.org>
	<20040914003425.GW642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:1169 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S269100AbUINB10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 21:27:26 -0400
In-Reply-To: <20040914003425.GW642@parcelfarce.linux.theplanet.co.uk> (Matthew
	Wilcox's message of "Tue, 14 Sep 2004 01:34:25 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org

Matthew Wilcox <willy@debian.org> writes:

> On Mon, Sep 13, 2004 at 11:33:05PM +0200, Matthias Andree wrote:
>> Urgh. There was a time when the driver was shared among deveral OSs,
>> among them FreeBSD. The BSD world ain't gonna like this for practical
>> reasons, the consequence is that they'll either stop merging patches
>> from Linux or remove the sym driver from their GENERIC kernels if they
>> want your patches.
>
> They already aren't using it.  I went and trawled their CVS trees for any
> bugfixes they might have done to the driver since Gerard went missing.
> FreeBSD is using 1.6.5 (ie the driver we removed shortly before 2.6).
> NextBSD and OpenBSD have their own driver (siop).

OK, no harm done, as you vigilantly checked before.

> Given that, I don't see the benefit to retaining BSD licence
> compatibility.  In addition, retaining dual BSD licencing allows others
> to take this driver and use it in proprietary OSes.  I don't like people
> being able to take without giving back.
>
> Now, if there's actual real interest from the BSD camps in using this
> driver, let's hear it, and I'll revert this change.  But keeping the
> BSD licence on it at this point looks like no benefit and only liability.

Sounds very reasonable.

Thanks for your quick response.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
