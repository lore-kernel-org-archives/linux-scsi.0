From: Kaushik Datta <kdatta@npd.hcltech.com>
Subject: scsi querry.
Date: Mon, 27 May 2002 17:54:29 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF2257D.8F80C37F@npd.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from npd.hcltech.com (kdatta-pc.hclt-ntl.co.in [192.168.19.63])
	by mailnpd.hcltech.com (8.11.0/8.11.0) with ESMTP id g4RCO3427536
	for <linux-scsi@vger.kernel.org>; Mon, 27 May 2002 17:54:05 +0530
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello ,

   I have a pseudo LLD module that has it's own queuecommand, abort handler  etc etc.
   But when a command comes via to queucommand and if due to certain reasons (specific
   to my module) the response of the command is not sent to the mid level ,(timeout condition)
   the SCSI mid level  error handler thread sets the scsi device offline.I have encountered this
   error message many a times. Now the return value of my abort handler function is
   SCSI_ABORT_SUCCESS and 'result' field as DID_ABORT.

   Even after this the mid level is setting the device offline

    Is that the correct behaviour ? I am using  lk 2.4.2 .

   Please correct me if my observations are wrong !

   Regards,
   Kaushik




