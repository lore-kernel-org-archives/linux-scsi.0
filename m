From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: 30 Sep 2004 09:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096552371.2062.11.camel@mulgrave>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
	<1096385921.2008.21.camel@mulgrave>
	<20040930130518.GB3167@krispykreme.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42664 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269282AbUI3Nwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 09:52:53 -0400
In-Reply-To: <20040930130518.GB3167@krispykreme.ozlabs.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-09-30 at 09:05, Anton Blanchard wrote:
> Im confused, why are we checking sdev earlier on? Unfortunately I dont
> have the machine at the moment, if I get it back I'll get a dmesg.

Erm, because I didn't notice it and forgot to remove it when I revamped
the negotiation routines...

James


