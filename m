From: Stelian Pop <stelian@popies.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 23:33:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424213355.GA1277@deep-space-9.dsnet>
References: <UTC200304241521.h3OFL7e14246.aeb@smtp.cwi.nl>
Reply-To: Stelian Pop <stelian@popies.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d146.dhcp212-198-27.noos.fr ([212.198.27.146]:55948 "EHLO
	deep-space-9.dsnet") by vger.kernel.org with ESMTP id S264455AbTDXVWd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 17:22:33 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304241521.h3OFL7e14246.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, stern@rowland.harvard.edu, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com

On Thu, Apr 24, 2003 at 05:21:07PM +0200, Andries.Brouwer@cwi.nl wrote:

> That is good. But there is one point I do not understand.
> Stelian Pop reports on two devices, both US_SC_UFI.
> But usb_stor_ufi_command() already contained code to
> make the length 8. How can it be that my sd.c change
> improved things?

Good question.

Could it be that the unusual_devs treatment is flawed somewhere ?

I'll enable debug traces in usb-storage tomorrow again and try to
trace this a bit more. If there is something more specific I need
to look at just tell me.

> Can it be that earlier tests were for 2.5.67 and later tests
> for 2.5.68, and Matt's improvements of the latter over the former
> are the real reason of improved behaviour?

No. I've done all tests (both without - resulting in failures - and
with the sd.c patch) with the latest 2.5 bk tree as of this morning.

The sd.c patch *is* needed to make it work.

Stelian.
-- 
Stelian Pop <stelian@popies.net>
