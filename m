From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5953] New: easyRAID F8 IDE2SCSI adaptor
 problems with reporting too many luns
Date: Wed, 25 Jan 2006 09:24:52 -0800
Message-ID: <20060125092452.42eb744b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25999 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932068AbWAYRZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 12:25:13 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k0PHP6DZ028393
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2006 09:25:12 -0800
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id k0PHP6FV026192
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2006 09:25:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Looks like an aic79xx problem.  Relatively recently-occurring, too.

Begin forwarded message:

Date: Wed, 25 Jan 2006 06:17:59 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5953] New: easyRAID F8 IDE2SCSI adaptor problems with reporting too many luns


http://bugzilla.kernel.org/show_bug.cgi?id=5953

            Summary: easyRAID F8 IDE2SCSI adaptor problems with reporting too
                     many luns
