From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] qla4xxx feature update
Date: Mon, 01 Aug 2011 12:28:10 -0500
Message-ID: <4E36E22A.5050007@cs.wisc.edu>
References: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44091 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab1HARZD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2011 13:25:03 -0400
In-Reply-To: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 08/01/2011 05:26 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Following patches are made over scsi-misc and Mike Christie's patchset
> posted here: http://marc.info/?l=linux-scsi&m=131161955801957&w=2
> 
> Harish Zunjarrao (3):
> 	qla4xxx: Code cleanup for read/update flash using BSG
> 	qla4xxx: Add get ACB state support using BSG
> 	qla4xxx: Add read/update NVRAM support for 40xx adapters using BSG
> 
> Vikas Chaudhary (5):
> 	scsi_transport_iscsi: Added support to update mtu
> 	qla4xxx: Added support to update mtu
> 	qla4xxx: Added vendor specific sysfs attributes
> 	scsi_transport_iscsi: Added support to update initiator iscsi port
> 	qla4xxx: added support to update initiator iscsi port
> 

Patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
