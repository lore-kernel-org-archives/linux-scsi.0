From: Lincoln Dale <ltd@cisco.com>
Subject: RE: qla2300 at only 1 GBit on kernel 2.6.5
Date: Thu, 06 May 2004 09:34:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040506093119.044aff90@171.71.163.14>
References: <B179AE41C1147041AA1121F44614F0B0DD0117@AVEXCH02.qlogic.org
 >
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:33449 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S264693AbUEEXeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2004 19:34:16 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD0117@AVEXCH02.qlogic.org
 >
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jan-Frode Myklebust <janfrode@parallab.uib.no>, linux-scsi@vger.kernel.org

At 06:50 AM 6/05/2004, Andrew Vasquez wrote:
> > Then I set the storage device to autodetect speed, rebooted, and then
> > it came up at 1 Gbit.
> >
>
>Negotiation problems -- ewww...  Ok, this is going to be challenging,

in my experience (FC switching, but an awful lot of it!), this could be a 
crappy/failing/stretched/trodden-on Fibre cable.
of the tens-of-thousands of optical patch cables here, anytime we've had a 
link at 1G that should be at 2G, typically replacing the cable has 'fixed' it.

of course, i've seen plenty of devices that don't necessarily follow FC-PH 
properly either ... :-|


cheers,

lincoln.

