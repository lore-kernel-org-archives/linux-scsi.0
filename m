From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] aacraid: Add module param to export disks as 'fixed' instead of 'removable'
Date: Wed, 18 May 2011 13:21:40 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9017776E1@XYUS-EX22.xyus.xyratex.com>
References: <4DD2CE01.9090403@suse.de> <20110517193544.GA27336@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60649 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab1ERUVz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 16:21:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20110517193544.GA27336@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Ankit Jain <jankit@suse.de>
Cc: linux-scsi@vger.kernel.org, aacraid@adaptec.com, Hannes Reinecke <hare@suse.de>

> On Wed, May 18, 2011 at 01:05:29AM +0530, Ankit Jain wrote:
> > aacraid: Add 'aac_export_fixed' module param to export disks as
> > 'fixed' instead of 'removable'.
> > Adaptec controllers set the removable flag on devices to
> > allow for reconfiguration. The fear is that _not_ setting this
> > flag would inhibit the OS from detecting any device reconfiguration.
> The flag should not be set at all and just be removed.

This will break the RAID Management Software, and various Firmware
features (snapshot, thin-provisioning etc)

Sincerely -- Mark Salyzyn
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


