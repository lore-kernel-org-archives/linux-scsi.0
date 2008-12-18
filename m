From: "tarrot termite" <tarrottermite@gmail.com>
Subject: Disabling scatter gather
Date: Thu, 18 Dec 2008 19:57:25 +0530
Message-ID: <1aa5e34d0812180627r56625723k840f5b8080335644@mail.gmail.com>
References: <5fdb3af3-6283-4ca4-856f-9028ed52f789@d36g2000prf.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.230]:43133 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYLRO11 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:27:27 -0500
Received: by qb-out-0506.google.com with SMTP id f11so233216qba.17
        for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2008 06:27:26 -0800 (PST)
In-Reply-To: <5fdb3af3-6283-4ca4-856f-9028ed52f789@d36g2000prf.googlegroups.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I am trying to disable scatter gather for my fake SCSI HBA driver but
somehow I still get use_sg set in my scsi commands.

I have set sg_tablesize to SG_NONE in host template. I remember it
used to work well in 2.4. Has this part change under 2.6.18?

appreciate quick help ..

Tarrot
