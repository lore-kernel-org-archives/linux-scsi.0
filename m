From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 12/15] lpfc: Fix rport leak.
Date: Wed, 27 May 2015 23:32:00 +0200
Message-ID: <20150527233200.00006352@localhost>
References: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>
	<20150524135636.00000f81@localhost>
	<5564755B.5030302@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbbE0VcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2015 17:32:05 -0400
In-Reply-To: <5564755B.5030302@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> Sebastian,
> 
> Re: more than 1 space between a type declaration and a variable name - I 
> do not believe that's a hard requirement. It fully passes checkpatch. 
> Yes, consistent style use (aligning all variable names at same offset, 
> or always 1) would be good - but code has been there so long with 
> althernate styles it doesn't really matter at this point.  I did clean 
> up those in your last review as I needed to do a mod for the LS_RJT 
> behavior. But... this seems like a nit.   I did promise Christoph that I 
> would pick a good point and retrofit the sources for all sparse warnings 
> - and still owe him.
> 
> Re: Checkpatch and string splitting. I understand we aren't passing 
> checkpatch for that rule, but joining them would have checkpatch 
> flagging us for beyond 80 character lines.

checkpatch seems to just follow what's mentioned in CodingStyle "Chapter 2:
Breaking long lines and strings":

"However, never break user-visible strings such as printk messages, because
that breaks the ability to grep for them."

The tool is actually smart enough to not flag such lines as LONG_LINE.

> I'd much rather have the 
> splits and keep the indenting for readability. We have also had this 
> error quite a bit in the past and believe we have been grandfathered as 
> there's a lot of this already.
> 
> James B - any comments on the above ?
> 
> -- james s

Sebastian
