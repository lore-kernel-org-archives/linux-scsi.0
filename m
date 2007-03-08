From: "renuka apte" <renuka.apte@gmail.com>
Subject: Transport ID in Persistent Reservation
Date: Thu, 8 Mar 2007 14:24:55 +0530
Message-ID: <6bd7946f0703080054u113ffd1aj1f4e2d90c8914a25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:17181 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316AbXCHIy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 03:54:57 -0500
Received: by ug-out-1314.google.com with SMTP id 44so867634uga
        for <linux-scsi@vger.kernel.org>; Thu, 08 Mar 2007 00:54:56 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The 'Specify Initiator Ports' support in persistent reservation allows
the application client to send a bunch of transport IDs which identify
initiator ports. I would like to know the suggested format for these
transport IDs.
I am assuming that it must have something to do with the WWN of the
initiator ports.
I tried using sg_utils to issue a persistent reservation IN command
with "READ FULL STATUS" to a virtual SCSI disk which is returning the
response in the format specified in SPC-4. However the sg_utils seems
to be decoding the transport ID in some way that I cant find in the
standard.
Thanks.
Renuka Apte.
