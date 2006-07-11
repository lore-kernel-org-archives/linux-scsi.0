From: "Robert Tarte" <robt@PacificCodeWorks.com>
Subject: RE: [PATCH] aic94xx: fix routing algorithms
Date: Tue, 11 Jul 2006 08:49:18 -0700
Message-ID: <16C8363E16D7234AB844FDB52D4AEA650C2DBB@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-67-101-118-101.snfccasy.covad.net ([67.101.118.101]:25002
	"EHLO PacificCodeWorks.com") by vger.kernel.org with ESMTP
	id S1751301AbWGKPpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2006 11:45:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


> No ... this is the programme in annex L of sas-2, isn't it?  Even if
it
> were available somewhere, the aic94xx doesn't yet have the necessary
SMP
> tap to try it.

[Tarte, Robert] I wrote an expander simulator that I ran in user space
for the adp94xx.  I extracted the routing code from the adp94xx driver
and ran through numerous configurations hand checking the table to make
sure that it came up with the right answer.

