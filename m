From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5] qla4xxx: Patches for scsi-misc
Date: Fri, 16 Dec 2011 15:14:05 -0600
Message-ID: <4EEBB49D.3010302@cs.wisc.edu>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42693 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395Ab1LPVOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 16:14:16 -0500
In-Reply-To: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 12/16/2011 03:58 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> James,
> 
> Please apply the following patches to scsi-misc for inclusion in mainline.
> 
> Lalit Chandivade (1):
>       qla4xxx: cleanup, make qla4xxx_build_ddb_list short
> 
> Manish Rangankar (1):
>       qla4xxx: Fixed BFS with sendtargets as boot index.
> 
> Nilesh Javali (2):
>       qla4xxx: Limit the ACB Default Timeout value to 12s
>       qla4xxx: Break the loop if the sendtargets list was empty
> 
> Vikas Chaudhary (1):
>       qla4xxx: Update driver version to 5.02.00-k11
> 
>  drivers/scsi/qla4xxx/ql4_os.c      |  419 +++++++++++++++++++++--------------
>  drivers/scsi/qla4xxx/ql4_version.h |    2 +-
>  2 files changed, 252 insertions(+), 169 deletions(-)
> 

Looks ok, but I think in some patches descriptions in the future you
should add a better description. In the 2nd patch there is no info about
if it fixes a bug or why you are doing it. We do not know what the JIRA
value is about.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
