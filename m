From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR
Date: 10 Nov 2003 10:30:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068485442.4495.25.camel@patrh9>
References: <1068479926.2313.7.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:59320 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264014AbTKJRbL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 12:31:11 -0500
In-Reply-To: <1068479926.2313.7.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: p.lavarre@ieee.org

> final wrong step forward deleted.  In this patch we do Not fetch the
> mmc drive-with-disc "profile" that we Now know so often appears not
> "currently active".
> 
> ... relevant rumours ... 1) ... 2) ... 3) ...

Slanderous or not, also I hear:

4) "Feature" x0020 RandomWritable appears present, though not "current",
in the op x46 Get Configuration data which Windows fetches to begin life
after plug in.

5) Feature x0020 appears neither present nor current in drives that
accept only the "not-so-very rewritable-in-place DVD+RW discs", rather
than "truly rewritable dvd discs such as dvd-ram".

Pat LaVarre


