From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 5 Nov 2004 12:29:19 -0500
Message-ID: <04Nov5.122856est.333839@cyborg.cybernetics.com>
References: <418BA535.5070403@babut.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:38411 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262714AbUKESLO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 13:11:14 -0500
In-Reply-To: <418BA535.5070403@babut.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Thomas Babut' <thomas@babut.net>, linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

> scsi0 : sym53c8xx-1.7.3c-20010512
> scsi1 : sym53c8xx-1.7.3c-20010512

There are two LSI Logic drivers in lk 2.4.27: sym53c8xx and sym53c8xx_2.
You are using the older sym53c8xx driver here.  In 2.6.x, only
sym53c8xx_2 exists.  So you changed two variables at once:

sym53c8xx -> sym53c8xx_2
lk 2.4.27 -> lk 2.6.x

It might be useful to know how sym53c8xx_2 behaves in lk 2.4.27.

Anthony J. Battersby
Cybernetics

