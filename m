From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Fri, 19 Jul 2013 09:56:09 -0600
Message-ID: <51E96199.2040903@cs.wisc.edu>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38349 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643Ab3GSP4T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jul 2013 11:56:19 -0400
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adheer.chandravanshi@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

On 07/08/2013 06:33 AM, adheer.chandravanshi@qlogic.com wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest
> convenience.
> 
> Adheer Chandravanshi (7):
> 	qla4xxx: Allow removal of failed session using logout.
> 	qla4xxx: Use discovery_parent_idx instead of discovery_parent_type
> 	qla4xxx: Set IPv6 traffic class if device type is IPv6.
> 	qla4xxx: discovery_parent_idx can be shown without any check.
> 	qla4xxx: Only BIOS boot target entries should be at index 0 and 1.
> 	qla4xxx: Export more firmware info in sysfs
> 	qla4xxx: Update driver version to 5.03.00-k11
> 


Ignore my comment on that one patch. Patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

