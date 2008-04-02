From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Wed, 2 Apr 2008 12:29:44 +0200
Message-ID: <20080402122944.7fe8e924.seraph@xs4all.nl>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	<20080401011518.eb683cff.akpm@linux-foundation.org>
	<1207059115.3100.9.camel@localhost.localdomain>
	<20080401210521.abbb443c.seraph@xs4all.nl>
	<1207081169.3100.20.camel@localhost.localdomain>
	<20080401225717.7d936f91.seraph@xs4all.nl>
	<1207084454.3100.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearlgates.net ([82.92.180.13]:46673 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYDBK3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 06:29:47 -0400
In-Reply-To: <1207084454.3100.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

Maybe it's nothing, but I did notice that sym53c8xx compiles with a warning of a possibly uninitialized variable:

  CC [M]  drivers/scsi/sym53c8xx_2/sym_glue.o
drivers/scsi/sym53c8xx_2/sym_glue.c: In function 'sym_eh_handler':
drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: 'io_reset' may be used uninitialized in this function


-- 
Jos van der Ende <seraph@xs4all.nl>
