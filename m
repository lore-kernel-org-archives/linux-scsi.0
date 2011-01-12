From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: build failure of drivers/scsi/gdth.c
Date: Wed, 12 Jan 2011 12:29:19 +0200
Message-ID: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:19679 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696Ab1ALK3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jan 2011 05:29:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I got into that with 2.6.37 after adding some dynamic debug
configs (I can send the compressed .config if needed)

The same/similar problem happens also for the few more places
which use LINUX_VERSION_CODE

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC [M]  drivers/scsi/gdth.o
drivers/scsi/gdth.c: In function gdth_ioctl:
drivers/scsi/gdth.c:4510: error: expected expression before >> token
drivers/scsi/gdth.c:4511: error: expected expression before >> token
drivers/scsi/gdth.c:4512: error: invalid lvalue in unary
make[2]: *** [drivers/scsi/gdth.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
