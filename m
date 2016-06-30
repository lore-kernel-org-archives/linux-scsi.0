From: Baoquan Zhang <zhan4281@umn.edu>
Subject: DIF/DIX in mpt3sas
Date: Wed, 29 Jun 2016 19:57:24 -0500
Message-ID: <59D68167-CD5A-4CD6-8382-7DA70A4B268C@umn.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:60721 "EHLO
	mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcF3BxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2016 21:53:01 -0400
Received: from localhost (unknown [127.0.0.1])
	by mta-p6.oit.umn.edu (Postfix) with ESMTP id CF9E77CD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2016 00:57:10 +0000 (UTC)
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
	by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HzbDzdpXIhUq for <linux-scsi@vger.kernel.org>;
	Wed, 29 Jun 2016 19:57:10 -0500 (CDT)
Received: from mail-it0-f72.google.com (mail-it0-f72.google.com [209.85.214.72])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mta-p6.oit.umn.edu (Postfix) with ESMTPS id B06C27B8
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 19:57:10 -0500 (CDT)
Received: by mail-it0-f72.google.com with SMTP id f6so132269481ith.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 17:57:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alireza Haghdoost <haghdoost@gmail.com>, du <du@cs.umn.edu>, Raghu Raja Chandrasekar <raghu@cray.com>

Hi there,

Thanks for reading my email.

I am a Ph.D student of University of Minnesota, Twin Cities. Recently, I am working on a project of T10 PI-capable MD module. However, I fail to use DIX with the HBA/driver combination of LSI Logic / Symbios Logic SAS3008 PCI-Express Fusion-MPT SAS-3 (rev 02) /mpt3sas even though I have formatted the drives with DIF protection type 1. May I know if DIX (data integrity extension) is supported in mpt3sas driver?

Thanks,
Baoquan Zhang