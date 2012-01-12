From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/7] qla4xxx: Cleanup modinfo display
Date: Wed, 11 Jan 2012 20:01:20 -0600
Message-ID: <4F0E3EF0.7030106@cs.wisc.edu>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com> <1326278661-16368-7-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48237 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2ALBxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2012 20:53:25 -0500
In-Reply-To: <1326278661-16368-7-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Karen Higgins <karen.higgins@qlogic.com>

On 01/11/2012 04:44 AM, vikas.chaudhary@qlogic.com wrote:
>  
> -int ql4xextended_error_logging = 0; /* 0 = off, 1 = log errors */
> +int ql4xextended_error_logging = 0;

You do not need to init this to 0 like above. It gets set to zero for
you. I think this is some codingstyle doc rule violation. You should run
checkpatch.pl on your patches before sending to catch this type of stuff.

It is probably ok since it was there before and you are not adding it
and your patch is focused on other stuff, but you should clean it up one
day and make note of it for the future.
