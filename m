From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 18:34:39 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <012101c3ae9d$b0a3d010$8f074d0a@apac.cisco.com>
References: <20031027153932.A16679@infradead.org>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:32554 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264060AbTKSNEo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:04:44 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

Hi Christopher,
	Could you please elaborate on this review comment? 
	- kill ctl_open/ctl_release and move add an owner to the fops
structure for refcounting.

Especially, what do you mean by "move add an owner to the fops structure
for refcounting" ? We already use the .owner field in the
file_operations template. What else are you refering to?


Thanks,
Sachin



