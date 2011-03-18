From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/13] qla4xxx: Updates for scsi-misc-2.6
Date: Thu, 17 Mar 2011 22:49:27 -0500
Message-ID: <4D82D647.7050002@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA872263B1506@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52660 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1CRDtF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 23:49:05 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA872263B1506@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Sarang Radke <sarang.radke@qlogic.com>

On 03/14/2011 12:23 AM, Vikas Chaudhary wrote:
> James,
>
> Please apply these patches on scsi-misc-2.6 tree.
>
> Karen Higgins (2):
>        qla4xxx: cleanup DDB relogin logic during initialization
>        qla4xxx: Prevent other port reinitialization during remove_adapter
>
> Prasanna Mumbai (3):
>        qla4xxx: Do not send mbox command if FW is in failed state
>        qla4xxx: Do not retry ISP82XX initialization if H/W state is failed
>        qla4xxx: masking required bits of add_fw_options during initialization
>
> Sarang Radke (1):
>        qla4xxx: Use polling mode for disable interrupt mailbox completion
>
> Vikas Chaudhary (7):
>        qla4xxx: cleanup qla4xxx_initialize_ddb_list()
>        qla4xxx: remove unused ddb flag DF_NO_RELOGIN
>        qla4xxx: cleanup function qla4xxx_process_ddb_changed
>        qla4xxx: Add support for ql4xmaxqdepth command line parameter
>        qla4xxx: add support for ql4xsess_recovery_tmo cmd line param
>        qla4xxx: added new function qla4xxx_relogin_all_devices
>        qla4xxx: Update driver version to 5.02.00-k6
>

Patches look ok with updated 06/13 patch. James, Vikas actually sent a 
couple revisions of 06/13. The final one is here:
http://marc.info/?l=linux-scsi&m=130035150917342&w=2

I could not compile/checkpatch test the patches, because my 
mailer/browser keeps replacing = with =D. Other people seem to be able 
to see it ok, so I think it is problem on my side. Code was reviewed.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
