From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: Removing the qlogicfc driver
Date: Mon, 19 Jan 2004 09:28:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E43@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:39208 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265331AbUASR15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:27:57 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "christophe.varoqui" <christophe.varoqui@free.fr>
Cc: linux-scsi@vger.kernel.org

On Sunday, January 18, 2004 1:15 PM, christophe.varoqui wrote:
> 2 independant switches,
> each HBA connected to a different switch.
> 
> Here are the required info on one of them (QLA2200 in port 3) :
> 

Thanks.  I have some firmware engineers looking at the 
information.  There was another problem reported on linux-scsi
with respect to undetected storage (subject: 'No LUNs detected 
with 2.6.1-mm4 qla2xxx / qla2300' and '[patch] Have qla2xxx 
driver bind fcports.', _but_ I don't believe that to be your 
problem since the driver is having problems discovering any 
devices.

Regards,
Andrew Vasquez
