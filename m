From: James.Smart@Emulex.Com
Subject: RE: [Patch RFC] Add FC transport host attributes
Date: Thu, 14 Oct 2004 16:11:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F214@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57578 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267421AbUJNUL4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 16:11:56 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu


> 
> Any chance you can kill all those host_port prefixes?

The "host" prefix is a byproduct of declaring host, target, and sdev attributes in the same file via CLASS_DEVICE_ATTR(), as we have it today in the transport files. Works fine if there is no name collision between the different objects. However, the names do collide between the target and host objects for FC. Do you have a suggestion ? (splitting the file into multiple files ?) 

The "port" prefix - sure, we can kill it. It simply inherited the name as per the hbaapi definition. I'd like to hear another couple aye's before making this change. 

-- James
