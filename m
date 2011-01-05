From: torn5 <torn5@shiftmail.org>
Subject: Will drive flush cache on cable disconnect?
Date: Wed, 05 Jan 2011 17:06:41 +0100
Message-ID: <4D249711.8040205@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.isti.cnr.it ([194.119.192.4]:1295 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1AEQGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 11:06:31 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW9STQKB34NG7F6S@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Wed, 05 Jan 2011 17:06:27 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW9STPLLOWNG77AB@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Wed, 05 Jan 2011 17:06:24 +0100 (MET)
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31826)
 with ESMTPSA id <01NW9STO73GYNXKFZM@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Wed, 05 Jan 2011 17:06:22 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Sorry I am slightly OT

If I disconnect the SATA / SAS cable, or I suddenly power off the 
computer with the controller (this can be done if the drive is on a JBOD 
chassis with separate power) will the HDD/SSD go ahead flushing all 
write-cache content to the platters / flash media? (and so I would get a 
consistent filesystem/database on power on)

Or will it get mad when it returns completion for each write command and 
nobody is listening on the other end of the cable? (cable disconnected 
or controller powered off)

Now another question:
When the drive is doing cached writes (cache on), without NCQ 
(queue_depth at 1), is the "completion" returned immediately upon 
receiving the write command, or is it returned later when the data goes 
to the platters? If it's the latter, what is the difference with NCQ 
(queue_depth > 1) then?

Thank you
