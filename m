From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: PATCH [3/5]  qla2xxx: TCQ fixes
Date: Tue, 13 Jul 2004 10:24:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD02FD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:710 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265649AbUGMR1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:27:08 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Monday, July 12, 2004 2:41 PM, James Bottomley wrote:
> 
> For the way the qla2xxx works, the correct tag usage would be to use
> per HBA tags (which were introduced for aic7xxx but never used by
> them, so I haven't actually created the mid-layer API), to populate
> your queue handle field with the tag and to dispense with your
> outstanding_cmnds[] array
>

Ok, I'll bite.  What did you have in mind? I've taken a quick peek
through the scsi code, the per-hba tag stuff must still be in your
head...

> and use scsi_find_tag() to get back the command from the handle. 
> 

Just a small comment, isn't the scsi_populate_tag_msg() function
quietly truncating the request->tag value?

Regards,
Andrew Vasquez
