From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 14:09:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825120905.GA16888@suse.de>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com> <20040825092541.GA15466@suse.de> <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:12735 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267164AbUHYMJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 08:09:23 -0400
Content-Disposition: inline
In-Reply-To: <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

 On Wed, Aug 25, Matthew Wilcox wrote:

> How about hacking the ppc64 bootloader to always pass inq_timeout=3D3=
0 instead?

I did not know that value was tuneable (havent looked at the code using
it). That would be an option, sure.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
