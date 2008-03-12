From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: affordable SAS HBA recommendation?
Date: Wed, 12 Mar 2008 19:23:31 -0400
Message-ID: <200803122323.m2CNNaM0030418@colby.verdasys.com>
References: <7.1.0.9.2.20080306154402.14f7d8f0@alum.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colby.verdasys.com ([69.20.67.85]:54078 "EHLO
	colby.verdasys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLXXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 19:23:41 -0400
In-Reply-To: <7.1.0.9.2.20080306154402.14f7d8f0@alum.mit.edu>
References: <7.1.0.9.2.20080306154402.14f7d8f0@alum.mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

At 16:53 3/6/2008, Marc Bejarano wrote:
 >i've been having some data corruption problems and i'd like to try
 >using a different driver/HBA to see if they go away.  i'm currently
 >using LSI SAS3801E HBA's which use the mptsas driver.  since i use
 >linux md for RAID, i'd rather not spend a lot of money on RAID silicon
 >that i don't want.
 >
 >ideally, i'd love a reasonably priced PCIe SAS HBA with an in-tree
 >driver supported by RHEL 5.1.  any suggestions?

apparently not :P

for the next lost soul, i found that marvell, LSI, and intel make 
affordable PCIe SAS chips.

marvell's 88SA6640 HBA doesn't seem to be available, yet.  in any 
case, mvsas (if that's the right LLD) is still too new for RHEL support.

LSI's HBA's are what i'm currently using and would recommend.

intel has the IOP348 chip (an emulex clone?) which is currently 
shipping in the Atto ExpressSAS H380 and friends.  atto's web page 
for the HBA says there is linux support, but i don't know what driver it uses.

if you're okay with PCI-X, adaptec's 58300 fits the bill.

hth,
marc

