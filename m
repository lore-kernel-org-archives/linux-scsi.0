From: Brian King <brking@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Mon, 19 Jan 2004 18:07:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400C7143.8010500@us.ibm.com>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:43952 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265193AbUATAHd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 19:07:33 -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

I just submitted a new LLD to linux-scsi and Christoph suggested I use 
this patch for setting SCSI bus attributes. I looked through the patches 
and noticed that these are per device attributes. I need to be able to 
set per SCSI bus attributes. The attributes I would like to be able to 
set include: initiator ID, maximum bus speed, wide enabled/disabled, and 
device spinup delay. Would it make sense to create a scsi_bus class or 
something similar for these types of attributes?



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

