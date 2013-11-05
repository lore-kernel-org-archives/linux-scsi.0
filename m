From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Tue, 05 Nov 2013 09:09:55 -0800
Message-ID: <52792663.1030101@cs.wisc.edu>
References: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56402 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3KERLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Nov 2013 12:11:50 -0500
In-Reply-To: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adheer.chandravanshi@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

On 10/18/2013 06:01 AM, adheer.chandravanshi@qlogic.com wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> 
> James,
> 
> Following patches support setting and display of addition network
> parameters for iSCSI interface.
> 
> Please apply these patches to the iscsi tree "misc" branch at your
> earliest convenience.
> 
> Mike,
> 
> All the changes as per your comments are incorporated in this version
> of the patch-set.
> 
> 
> Adheer Chandravanshi (1):
>   qla4xxx: Update driver version to 5.04.00-k2
> 
> Harish Zunjarrao (3):
>   iscsi_transport: Remove net param enum values
>   iscsi_transport: Additional parameters for network settings
>   qla4xxx: Add support for additional network parameters settings
> 

Patches look ok. The description on patch 1 and 2 should be iface params
instead of net, but I think it is ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

