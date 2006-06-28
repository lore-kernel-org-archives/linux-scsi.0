From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] reroll of sas ports patch
Date: Wed, 28 Jun 2006 15:34:41 -0400
Message-ID: <1151523281.3377.35.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701BDE93@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27033 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751038AbWF1Teo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 15:34:44 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701BDE93@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-06-28 at 13:28 -0600, Moore, Eric wrote:
> Thanks, but can we have a better way in keeping track of the unique
> expander numbers than using rphy->scsi_target_id?  I get confused when
> I see the target id there in the code.

Um, what do you suggest?  just renaming the variable?

James


