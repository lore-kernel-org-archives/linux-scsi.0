From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH 1/1] AACRAID driver update patch version - 28000
Date: Wed, 23 Mar 2011 08:38:09 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9016B46EA@XYUS-EX22.xyus.xyratex.com>
References: <340C71CD25A7EB49BFA81AE8C83926670E888C4F@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:43227 "HELO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933172Ab1CWPkZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 11:40:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <340C71CD25A7EB49BFA81AE8C83926670E888C4F@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>

I was on leave, sorry for the delay. I reinspected the patch and it
looks good IMHO. A global name ALIGN32 may have been a bit presumptuous
(AAC_ALIGN32?) but there is no collisions with existing upstream
definitions within the Linux source tree so No Big Deal.
Drivers/net/wan/wanxl.h also presumptuously used an ALIGN32() definition
so there is precedence.

This room is clean :-)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mahesh
Rajashekhara
Sent: Thursday, March 17, 2011 5:11 AM
To: James.Bottomley@suse.de; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Achim Leubner; Tony Ruiz
Subject: RE: [PATCH 1/1] AACRAID driver update patch version - 28000

Hi James,

Thanks for your comments.

We have added the changes suggested by Mark Salyzyn in this driver
patch.

. . .
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


