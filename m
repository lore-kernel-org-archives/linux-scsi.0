From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Thin provisioning trivial Update
Date: Sat, 26 Feb 2011 12:19:36 -0500
Message-ID: <4D693628.7090301@interlog.com>
References: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55257 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1BZRTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Feb 2011 12:19:46 -0500
In-Reply-To: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shyam.iyer.t@gmail.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 11-02-26 01:59 AM, shyam.iyer.t@gmail.com wrote:
> The first patch logs a kernel warning message for the THIN PROVISIONING SOFT THRESHOLD REACHED Unit Attention
> The second patch adds the THIN PROVISIONING SOFT THRESHOLD REACHED Unit Attention to scsi constants

As of SBC-3 draft revision 25 (27 October 2010) most
uses of "thin provisioning" have been renamed
"logical block provisioning". Further changes in
this direction occurred in SBC-3 draft revision 26
and I suspect there are more to come.

However thin provisioning lives on, essentially as a
special case of logical block provisioning. As of the
current drafts of SBC-3 and SPC-4 additional sense
code 38h,7h has the description you have given.


Memo to Martin Petersen and myself: scsi_debug needs
options and variables renamed due to these changes by
t10.

Doug Gilbert
