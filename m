From: Gabriel C <nix.or.die@googlemail.com>
Subject: drivers/scsi/sym53c416.c - address of 'sym53c416*' will always evaluate
 as 'true' , warnings
Date: Sun, 22 Jul 2007 15:52:21 +0200
Message-ID: <46A36115.3070600@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:29962 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXGVNyh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 09:54:37 -0400
Received: by nf-out-0910.google.com with SMTP id g13so95213nfb
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 06:54:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Lieven Willems <lw_linux@hotmail.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org

Hi,

I got this warnings on current git with gcc 4.2.1 :


...

drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'

...


Regards,

Gabriel C
