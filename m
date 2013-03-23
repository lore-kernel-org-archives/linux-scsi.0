From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] qla4xxx: Patches for iSCSI flash node mgmt support
Date: Sat, 23 Mar 2013 01:28:55 -0500
Message-ID: <514D4BA7.7060308@cs.wisc.edu>
References: <1363952492-16205-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60718 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab3CWG3F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Mar 2013 02:29:05 -0400
In-Reply-To: <1363952492-16205-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com

On 03/22/2013 06:41 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Following patches allows iscsiadm to manage iSCSI target information
> stored on adapter flash on per host basis and and perform various
> operations like add, delete, login, logout, and update the target
> information.
> 
> Please apply these patches to the scsi tree "misc" branch at your
> earliest convenience.
> 
> Adheer Chandravanshi (3):
>       scsi_transport_iscsi: Add flash node mgmt support
>       libiscsi: export function iscsi_switch_str_param
>       qla4xxx: Add flash node mgmt support
> 

In the last patch, the

+#define DEV_TYPE_IPV4  "ipv4"
+#define DEV_TYPE_IPV6  "ipv6"

should probably go in the iscsi class, but if it is ok with James then I
think that can be done in a later cleanup patch since there has been a
lot of work done on these patches already and we should get them in.
