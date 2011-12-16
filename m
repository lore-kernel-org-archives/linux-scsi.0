From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/5] qla4xxx: Limit the ACB Default Timeout value to 12s
Date: Fri, 16 Dec 2011 22:18:09 +0100
Message-ID: <1324070289.10429.16.camel@dabdike>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
	 <1324029539-26021-3-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50797 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760696Ab1LPVSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 16:18:14 -0500
In-Reply-To: <1324029539-26021-3-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

On Fri, 2011-12-16 at 01:58 -0800, vikas.chaudhary@qlogic.com wrote:
> From: Nilesh Javali <nilesh.javali@qlogic.com>
> 
> JIRA Key: UPSISCSI-205
> 
> Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

OK, that's enough.  The JIRA key is completely useless to anyone outside
Qlogic as a patch description.  Please document what's wrong and what
you're doing rather than quoting something that won't be as durable as
the git log.

James


