From: djshetty <dhirajshetty.junk@mailnull.com>
Subject: Some doubts in Persistent Reservation
Date: Thu, 23 Nov 2006 23:55:16 -0800 (PST)
Message-ID: <7519006.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:36063 "EHLO talk.nabble.com")
	by vger.kernel.org with ESMTP id S1757641AbWKXHzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 02:55:16 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1GnVu0-0000U0-7o
	for linux-scsi@vger.kernel.org; Thu, 23 Nov 2006 23:55:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I have been trying to understand PERSISTENT RESERVATION as per SCSI SPC-3
standards. I had the following two doubts:
   1. Is persistent reservation applied on a target port or on a particular
LUN connected to a target port. The SCOPE of persistent reservation says
"Entire LOGICAL UNIT", whereas the registration is done for a target PORT.
Hence the confusion.
   2. Is there any precise use of the PRGeneration key? I guessed it must be
used for knowing whether any changes have been on the target (with regards
to persistent reservation) since the previous command executed. 

Regards,
Dhiraj.
-- 
View this message in context: http://www.nabble.com/Some-doubts-in-Persistent-Reservation-tf2696285.html#a7519006
Sent from the linux-scsi mailing list archive at Nabble.com.

