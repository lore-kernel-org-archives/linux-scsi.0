From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 12:13:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825191344.GA9784@us.ibm.com>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com> <20040825092541.GA15466@suse.de> <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk> <1093440188.2050.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:22781 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268310AbUHYTPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 15:15:24 -0400
Content-Disposition: inline
In-Reply-To: <1093440188.2050.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <willy@debian.org>, Olaf Hering <olh@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

James or Matthew,
	Was the SYM_VERSION number going to be advanced post this
	change? I guess I can use the checksum now that the driver is
	using MODULE_VERSION, but it would be nice if the version
	advanced beyond 2.1.18j.

-andmike
--
Michael Anderson
andmike@us.ibm.com

