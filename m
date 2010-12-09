From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Is it possible to issue device reset to PMC PM8388 expander using
 sg3_utils or smp_utils?
Date: Thu, 09 Dec 2010 10:41:00 -0800
Message-ID: <4D0122BC.8060501@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61992 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0LISlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 13:41:16 -0500
Received: by fxm18 with SMTP id 18so2747795fxm.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Dec 2010 10:41:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

Is it possible to issue a low level device reset to a PMC-Sierra PM8388 
24x3G SAS expander using either sg3_utils or smp_utils?

I am able to enumerate and read the status of the phys on the PM8388, 
read end device information, etc. I tried sg_reset and it does a bus 
reset but not an expander reset.

Technical documentation on the PM8388 is not readily available so I do 
not know if it has a mode select bit or other special method to get the 
expander to reset itself.

I am looking for an inband method to reset the expander to clear a 
condition where some phys in a wide connection fail to link. A power 
cycle clears the condition and I am looking to mimic a power cycle by 
bouncing the expander at the lowest level possible via the SAS host 
connection.

Thank you.

--Jeff
