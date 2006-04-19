From: Tony Mantler <nicoya@ubb.ca>
Subject: QLogic qla2xxx firmware
Date: Wed, 19 Apr 2006 16:42:04 -0500
Message-ID: <61312D45-4977-470A-B750-2F5774C16157@ubb.ca>
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from S01060080c85517f6.wp.shawcable.net ([24.79.196.167]:35234 "EHLO
	ubb.ca") by vger.kernel.org with ESMTP id S1751173AbWDSVmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 17:42:11 -0400
Received: from kiska.fast ([192.168.1.3])
	by ubb.ca with esmtps (TLS-1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.61)
	(envelope-from <nicoya@ubb.ca>)
	id 1FWKR3-0001de-Pr
	for linux-scsi@vger.kernel.org; Wed, 19 Apr 2006 16:42:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reading the config help for the qla2xxx driver in 2.6.16 indicates  
that the firmware for the various cards can be downloaded from <ftp:// 
ftp.qlogic.com/outgoing/linux/firmware/>. This FTP directory exists,  
but is empty.

I'm rather concerned that my QLA2100 is going to stop working if I  
update to this or future kernels without first retrieving a firmware  
image. Is this correct? Where should this firmware be found if not  
from the indicated URL?


Cheers - Tony 'Nicoya' Mantler :)

--
Tony 'Nicoya' Mantler - Master of Code-fu
-- nicoya@ubb.ca -- http://www.ubb.ca/ --



