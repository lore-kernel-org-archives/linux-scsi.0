From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BUG] Fusion MPT Base Driver initialization failure with kdump
Date: Tue, 12 Jul 2005 12:23:27 -0400
Message-ID: <1121185408.4825.22.camel@mulgrave>
References: <1121147809.10622.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12707 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261790AbVGLRwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 13:52:49 -0400
In-Reply-To: <1121147809.10622.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharata@in.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-07-12 at 11:26 +0530, Bharata B Rao wrote:
> Fusion MPT base driver fails during initialization when kdump capture
> kernel boots. The details of the problem are reported here:

This bug report is pretty useless to me because I do a lot of my email
when I'm offline, so I can't get to the bugzilla report and you supply
no other details.

Also, we've invested quite a bit of effort persuading IBM to alter the
kernel bugzilla to collect email replies into the bug report, so if you
wish to bother the email list it should be

1. With the full bug report that allows people actually to assess the
problem
2. cc'd to the correct bugzilla address so that bugzilla itself collects
any replies and suggestions.

James


