From: "Czerkowicz, John" <john.czerkowicz@hp.com>
Subject: RE: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries
Date: Mon, 19 Apr 2004 09:49:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CE@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail05.zma.compaq.com ([161.114.64.105]:40968 "EHLO
	zmamail05.zma.compaq.com") by vger.kernel.org with ESMTP
	id S264449AbUDSNt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2004 09:49:56 -0400
Received: from tayexg12.americas.cpqcorp.net (tayexg12.americas.cpqcorp.net [16.103.130.103])
	by zmamail05.zma.compaq.com (Postfix) with ESMTP id BCBDE257F
	for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2004 09:49:53 -0400 (EDT)
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Kurt,

These devices have a tape drive at LUN 0 and a loader device at LUN 1.
Without this patch, only the tape drive at LUN 0 is detected.  After
applying this patch, both the drive and loader are detected.

Regards,
John

-----Original Message-----
From: Kurt Garloff [mailto:garloff@suse.de]
Sent: Sunday, April 18, 2004 2:31 PM
To: Czerkowicz, John
Cc: Linux SCSI list
Subject: Re: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries

On Fri, Apr 16, 2004 at 04:29:50PM -0400, Czerkowicz, John wrote:
> The following HP DAT autoloaders have devices at LUN 1:
> 
> HP SureStore DAT8x6
> HP SureStore DAT24x6
> HP SureStore DAT40x6
> HP StorageWorks DAT72x6

Why do you need FORCELUN for this?
They should be detected without any blacklist entries.

Regards,
-- 
Kurt Garloff  <garloff@suse.de>                            Cologne, DE 
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)
