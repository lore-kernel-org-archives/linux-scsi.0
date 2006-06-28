From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] reroll of sas ports patch
Date: Wed, 28 Jun 2006 15:47:25 -0400
Message-ID: <1151524045.3377.40.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701BDE9E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43161 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751121AbWF1Tr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 15:47:29 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701BDE9E@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-06-28 at 13:36 -0600, Moore, Eric wrote:
> Yes, since its really not the target id.  

Sure .. it's one of Christoph's originals ... I just reused it for
expanders because it made sense.  It's really just a general index
count.

Just find a nicer name and send a patch.

James


