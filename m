From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: 13 Jul 2004 09:29:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089728978.1798.16.camel@mulgrave>
References: <20040712140558.GA6961@praka.san.rr.com>
	<1089668486.1799.62.camel@mulgrave> <40F32AAE.5070508@us.ibm.com>
	<40F348C4.7070600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15021 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265255AbUGMOaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 10:30:05 -0400
In-Reply-To: <40F348C4.7070600@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Mike Christie <mikenc@us.ibm.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net, Krishna Murthy <krmurthy@cisco.com>

On Mon, 2004-07-12 at 21:28, Brian King wrote:
> ipr is not interested in the tag numbers either, as the adapter 
> microcode generates them.

Well, so does the qla2xxx.  However, all such implementations use driver
to controller handles which are direct tag equivalents (even if they're
not the actual tags sent over the wire). "Tag" in this sense merely
means identifying number from driver to host.

James


