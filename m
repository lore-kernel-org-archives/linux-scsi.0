From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Sat, 20 May 2006 22:05:42 -0600
Message-ID: <20060521040542.GA4241@parisc-linux.org>
References: <1148108792.13190.36.camel@amitarora.in.ibm.com> <20060521033428.61699.qmail@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:17616 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751422AbWEUEFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 May 2006 00:05:43 -0400
Content-Disposition: inline
In-Reply-To: <20060521033428.61699.qmail@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Amit Arora <aarora@in.ibm.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Sat, May 20, 2006 at 08:34:28PM -0700, Luben Tuikov wrote:
> As to your particular gripe: you're right.  But I doubt anything would
> get fixed or changed any time soon.  There is very little competence
> which also has power to change things in the SCSI part of the Linux.
> Take a look at the SCSI mailing list archives for good ol' laughs.

Hey, Luben.  Nice to hear from you again.  Unfortunately, you seem to
have forgotton to attach a patch to solve this particular issue.
