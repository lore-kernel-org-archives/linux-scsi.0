From: "dan carpenter" <error27@email.com>
Subject: megaraid on opteron w/ 8G RAM
Date: Wed, 10 Mar 2004 21:18:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311021847.B02281D7244@ws3-3.us4.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67]:6318 "EHLO
	webmail-outgoing.us4.outblaze.com") by vger.kernel.org with ESMTP
	id S262941AbUCKCSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 21:18:48 -0500
Received: from wfilter.us4.outblaze.com (wfilter.us4.outblaze.com [205.158.62.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id CEFCF1801356
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 02:18:47 +0000 (GMT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

I'm using the megaraid 1.19.6 driver on RedHat Work Station 
x86_64.  It works great with only 4 gigs of RAM installed, 
but it locks up when I load the module with 8 gigs of RAM 
installed.  It generally locks up in the issue_scb_block() 
but it's not always consistent about which line it locks 
up on within that function.

On the default Suse Linux Enterprise Server 8 the module 
loads but after around 5 hours of running drive tests the 
drives stop responding.

I also tried the megaraid2 module and that kernel panics 
when the module is loaded.

I'm using an arima motherboard with the 1.84 BIOS.

Is this a known issue?  Has anyone been able to make a 
similar config work?

regards,
dan carpenter
-- 
___________________________________________________________
Sign-up for Ads Free at Mail.com
http://promo.mail.com/adsfreejump.htm

