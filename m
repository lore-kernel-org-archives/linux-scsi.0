From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] inia100.c: pointer used before being set
Date: 13 Jan 2004 10:07:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074006425.2173.13.camel@mulgrave>
References: <20040112210754.582573ad.rddunlap@osdl.org>
	<1073971028.5177.1.camel@mulgrave>
	<20040112213034.5fc5d1a6.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:45485 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264288AbUAMPHJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 10:07:09 -0500
In-Reply-To: <20040112213034.5fc5d1a6.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-01-13 at 00:30, Randy.Dunlap wrote:
> OK, I looked for scsi-patch trees and just didn't look in one
> named with "2.7" in it since I think that this should be fixed
> before then.

Yes, sorry, bad tree name...I picked it when I wasn't sure if I'd get
any of the driver patches in after 2.6.0....I'll rename it in the next
go around.

James


