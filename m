From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] qla4xxx: Update for scsi-misc
Date: Mon, 27 Feb 2012 16:37:38 -0600
Message-ID: <4F4C05B2.2010307@cs.wisc.edu>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53529 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2B0Wht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 17:37:49 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 02/27/2012 05:08 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Manish Rangankar (1):
>       qla4xxx: Add support for multiple session per host.
> 
> Mike Christie (2):
>       scsi_transport: Export CHAP index as sysfs attribute
>       qla4xxx: Export CHAP index as sysfs attribute
> 
> Nilesh Javali (2):
>       iscsi_transport: Add support to display CHAP list and delete CHAP entry
>       qla4xxx: Add support to display CHAP list and delete CHAP entry
> 
> Vikas Chaudhary (3):
>       qla4xxx: Fix sparse warning
>       qla4xxx: trivial cleanup
>       qla4xxx: Update driver version to 5.02.00-k15
> 

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
