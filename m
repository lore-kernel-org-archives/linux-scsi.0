From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Wed, 7 Nov 2007 13:51:44 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95F54@otce2k301.adaptec.com>
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com> <20071107173307.GB25560@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:56880 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbXKGSvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 13:51:47 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071107173307.GB25560@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] sez:
> Did anyone run the driver through sparse to see if we have 
> more issues like this?

There are some warnings from sparse, none like this one. I will deal
with the warnings ...

Sincerely -- Mark Salyzyn

