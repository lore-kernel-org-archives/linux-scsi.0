From: Steven Dake <sdake@mvista.com>
Subject: why store the search type in the ieee name field?
Date: Mon, 10 Feb 2003 15:45:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E482B9E.40803@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvista.com (persist.az.mvista.com [10.50.1.246])
	by zipcode.az.mvista.com (8.9.3/8.9.3) with ESMTP id QAA17927
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2003 16:05:04 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

I was wondering the reasoning behind the code

scsi_scan:734
        /*
         * All OK - store ID
         */
      name[0] = hex_str[id_search->id_type];

This corrupts a perfectly good IEEE unique identifier (WWN for FC 
drives).  Is there some usage for this in user space?

Thanks
-steve


