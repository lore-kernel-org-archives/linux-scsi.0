From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: use %zd format string for size_t
Date: Mon, 17 Oct 2016 13:59:08 -0400
Message-ID: <yq1wph6hn6b.fsf@sermon.lab.mkp.net>
References: <20161017123605.2217411-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48746 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753877AbcJQR7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 13:59:44 -0400
In-Reply-To: <20161017123605.2217411-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 17 Oct 2016 14:35:46 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, James Bottomley <JBottomley@Odin.com>, Sebastian Herbszt <herbszt@gmx.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> A recent bugfix introduced a harmless warning in the lpfc driver:
Arnd> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_write_firmware':
Arnd> drivers/scsi/lpfc/lpfc_logmsg.h:56:45: error: format '%ld' expects
Arnd> argument of type 'long int', but argument 9 has type 'size_t {aka
Arnd> const unsigned int}' [-Werror=format=]

Arnd> 'size_t' is always the same width as 'long' in the kernel, but the
Arnd> compiler doesn't know that. The %z modifier is what the standard
Arnd> expects to be used here, and this shuts up the warning.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
