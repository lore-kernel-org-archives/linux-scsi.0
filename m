From: Bradley Grove <bgrove@attotech.com>
Subject: ATTO 6G SAS/SATA HBA Driver
Date: Tue, 03 Sep 2013 13:11:49 -0400
Message-ID: <52261855.7050503@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:8014 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753389Ab3ICRLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 13:11:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Jason Seba <jseba@attotech.com>


James,

Now that we are finishing up development for our esas2r driver, we are 
planning to start work on a kernel driver for our PM8001 based 6G 
SAS/SATA HBA product.  We have some questions about the best way to proceed.

While we haven't done thorough testing, our hardware appears to work 
with the existing PM8001 kernel driver.   The problem is that the 
existing kernel driver doesn't support all the features of the hardware 
or match the feature set of the current closed source driver.   For 
example, our closed source driver supports SES emulation over I2C and 
SGPIO.  Our closed source driver also has custom PHY settings to support 
longer cable lengths.   We also have a set of propriety management tools 
we'd like to work with the open source driver, though it looks like the 
PM8001's sysfs interface provides most of the functionality we need.

What are our options for supporting these features?  I see that Adaptec 
had an out-of-tree driver for their PM8001 card that supports additional 
features.   We'd prefer to have a kernel driver that fully supports our 
hardware, either based on the existing PM8001 driver or our closed 
source code base.   Is that possible?

-- 
Bradley Grove
System Software Engineer
ATTO Technology, Inc.
Phone:  +1.716.691.1999 ext. 144
Fax +1.716.691.9353
"Powering the World's Networks & Storage"
