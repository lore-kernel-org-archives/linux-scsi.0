From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/6] qla4xxx: 5.04.00-k6: Updates for scsi "misc" branch
Date: Fri, 11 Apr 2014 12:31:30 -0500
Message-ID: <534826F2.8070000@cs.wisc.edu>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52950 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaDKRbq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 13:31:46 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com

On 04/09/2014 08:12 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to the scsi tree at your earliest convenience.
> 
> Adheer Chandravanshi (2):
>       qla4xxx: Fix smatch warning in func qla4xxx_get_ep_param
>       qla4xxx: Fix smatch warning in func qla4xxx_conn_get_param
> 
> Nilesh Javali (2):
>       qla4xxx: Export sysfs DDBs from DPC handler
>       qla4xxx: Fix memory leak for ha->saved_acb
> 
> Tej Parkash (1):
>       qla4xxx: Disable INTx interrupt for ISP82XX
> 
> Vikas Chaudhary (1):
>       qla4xxx: Update driver version to 5.04.00-k6
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

