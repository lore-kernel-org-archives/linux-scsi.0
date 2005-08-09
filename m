From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]  DEC hsg80 needs BLIST_REPORTLUN2
Date: Tue, 09 Aug 2005 12:51:38 -0500
Message-ID: <1123609899.5170.32.camel@mulgrave>
References: <1123608417.30193.23.camel@aptis101.cqtel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8073 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964897AbVHIRvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 13:51:43 -0400
In-Reply-To: <1123608417.30193.23.camel@aptis101.cqtel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wilcox <spwilcox@att.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 13:26 -0400, Steve Wilcox wrote:
> In order to properly report LUN's > 7, the DEC HSG80 definition in
> scsi_devinfo.c needs to include BLIST_REPORTLUN2 rather than
> BLIST_SPARSELUN.  I've tested this change with several HSG firmware
> revisions and with both Emulex and Qlogic HBA's.

Well, your patch won't apply.  Apart from the breaking by the mailer,
you have a curiosity in the last three lines (the DELL arrays) which are
definitely missing tabs and spaces over what we have in the kernel
(There are three spaces between "PV660F" and "PSEUDO" and there's a tab
not a space before the comment).  How did you generate this diff?

Anyway, I can apply the single change manually.

James


