From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 19 Jan 2004 16:13:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq065f7od4r.fsf@wildopensource.com>
References: <1074382860.1756.20.camel@mulgrave>
	<20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
	<20040118062157.GA11083@praka.local.home>
	<20040118073321.GC383498@sgi.com> <1074437655.1804.12.camel@mulgrave>
	<20040119174027.B3176@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:5314 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S263486AbUASVOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:14:34 -0500
In-Reply-To: <20040119174027.B3176@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <praka@users.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Sun, Jan 18, 2004 at 09:54:13AM -0500, James Bottomley
Christoph> wrote:
>> However, I have another question for you: Does the card BIOS
>> actually get to run on bootup?  It doesn't (because it can't) on
>> PA, so I get strange values for certain NVRAM quantities (like the
>> 32 bit mode, but more importantly, the offset of all my devices
>> gets set to 1).  I was thinking about doing an override to set them
>> more sensibly and wondered if you were having the same problem.

Christoph> Guys, given that problems with that nvram reading stuff
Christoph> show up again and again, shouldn't we rip out the code
Christoph> looking at the nvram completely?  Or at least disable it by
Christoph> default and enable it only by a module option (for both
Christoph> qla1280 and qla2xxx).

Christoph, I have thought about this before and while I agree in
principle that relying on BIOS settings is inherently broken, I am
also wary of changing a behavior a number of users are currently
relying upon.

Second, for qla2xxx you need a persistent place where you can store
the Fibre Channel ID (the name slips my mind right now).

Cheers,
Jes

