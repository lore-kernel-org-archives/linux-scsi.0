From: "Dupuis, Chad" <chad.dupuis@hp.com>
Subject: RE: patch for scsi_devinfo.c
Date: Mon, 21 Jun 2004 16:16:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A8B003DDA3332A479C0ECCA641F47E6503BE69FA@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail05.zma.compaq.com ([161.114.64.105]:55052 "EHLO
	zmamail05.zma.compaq.com") by vger.kernel.org with ESMTP
	id S266448AbUFUUQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2004 16:16:43 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

It does respond to report LUN.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
Sent: Monday, June 21, 2004 4:15 PM
To: Dupuis, Chad
Cc: SCSI Mailing List
Subject: Re: patch for scsi_devinfo.c


On Mon, 2004-06-21 at 15:07, Dupuis, Chad wrote:
> The entries for HP and Compaq HSV110 are incorrect.  The HSV110 
> controllers report themselves as SCSI 2 devices and therefore need the

> BLIST_LARGELUN flag to see LUNs passed 7.

Do they also respond to REPORT LUNS?  In which case we could flag them
as that instead of BLIST_SPARSELUN|BLIST_LARGELUN

James


