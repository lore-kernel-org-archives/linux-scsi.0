From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Wed, 5 Oct 2011 05:10:12 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE847@XYUS-EX22.xyus.xyratex.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com><1316691000.10571.6.camel@dabdike><FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com><FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com><A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn><CAA9_cmdq455AZJUPNdjCrn7JT90AXZtZbGGejcpLDX3zYfu+2A@mail.gmail.com><FC1F9E38C0703341A1A750524E2525A9018AE711@XYUS-EX22.xyus.xyratex.com><FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com> <CAA9_cmdAx7pw-2scX=mYP=i4zpAH+fAF-0WNM4cg97Ng6xFNAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:52843 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934506Ab1JEMLJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2011 08:11:09 -0400
Content-class: urn:content-classes:message
In-Reply-To: <CAA9_cmdAx7pw-2scX=mYP=i4zpAH+fAF-0WNM4cg97Ng6xFNAw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>

Our duplication is to send an out-of-band CLI command to a downstream
expander's Firmware and tell it to disable one of it's phys. Sounds
simple, but not when someone else has all the customized pieces and
serial cables ;-/ and the duplicator has moved on in priority.

Pregnant thought, smp_phy_control --phy=? --op=dis (wrong side, probably
too 'wide' of an aim) has not been tried ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
Behalf Of Dan Williams
Sent: Tuesday, October 04, 2011 7:31 PM
To: Mark Salyzyn
Subject: Re: [PATCH] [SCSI] libsas panic when single phy disabled on a
wide port

. . .

What is your reproduction scenario for this bug?  We see this in our
larger topology hotplug tests, but I don't think we have a simple
reproducer.
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


