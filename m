From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: patch for scsi_devinfo.c
Date: 21 Jun 2004 15:15:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087848910.2079.80.camel@mulgrave>
References: <A8B003DDA3332A479C0ECCA641F47E6503BE69F9@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35262 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266445AbUFUUPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 16:15:11 -0400
In-Reply-To: <A8B003DDA3332A479C0ECCA641F47E6503BE69F9@tayexc13.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@hp.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 15:07, Dupuis, Chad wrote:
> The entries for HP and Compaq HSV110 are incorrect.  The HSV110
> controllers report themselves as SCSI 2 devices and therefore need the
> BLIST_LARGELUN flag to see LUNs passed 7.

Do they also respond to REPORT LUNS?  In which case we could flag them
as that instead of BLIST_SPARSELUN|BLIST_LARGELUN

James


