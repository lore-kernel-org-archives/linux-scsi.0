From: christophe.varoqui@free.fr
Subject: RE: Removing the qlogicfc driver
Date: Tue, 20 Jan 2004 14:42:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074606124.400d302cac80e@imp2-l.free.fr>
References: <B179AE41C1147041AA1121F44614F0B0598E46@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:64928 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S265508AbUATNmM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 08:42:12 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E46@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Selon Andrew Vasquez <andrew.vasquez@qlogic.com>:
> 
> Ok, this turned out to be my mess-up.  As it turns out the 2200 fw
> doesn't support the MS IOCB interface the driver uses to issue CT
> commands to the SNS.  Basically, I had to forward-port some code 
> from the 6.x driver to get the SNS calls to go through.  I have
> several machines (mixture of 2200s/2300s/others with loop and 
> fabric connections) in my test rings running with the attached patch.
> If you would, I'd like for you to try out the attached patch.  It's
> delta'd against the qla2xxx driver in the -mm4 tree.
> 
> Please let me know how it works out for you.  I'd like to forward
> it along for inclusion once I get a bit more internal runtime in my
> rings.
> 
I report it works flawlessly with "2.6.0-udm5 (== mm2) + qla8b8 + patch".

Thanks for caring,
cvaroqui
