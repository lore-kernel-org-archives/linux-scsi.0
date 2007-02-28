From: "Daniel J. Priem" <daniel@flexserv.de>
Subject: Re: [PATCH] SCSI: Update ASC list and make it const
Date: Wed, 28 Feb 2007 18:45:27 +0100
Message-ID: <87d53utbuw.fsf@samuel.flexserv.de>
References: <yq1lkii420t.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46563 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXB1RuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 12:50:11 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HMSwE-0007yj-Q8
	for linux-scsi@vger.kernel.org; Wed, 28 Feb 2007 18:50:02 +0100
Received: from 213.217.69.53 ([213.217.69.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 18:50:02 +0100
Received: from daniel by 213.217.69.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2007 18:50:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:
> + * The canonical list of T10 Additional Sense Codes is available at:
> + * http://www.t10.org/lists/asc-num.txt+ */

Please do a

- * http://www.t10.org/lists/asc-num.txt+ */
+ * http://www.t10.org/lists/asc-num.txt */

its a typo.
Regards
Daniel

-- 
 .''`.
 : :' :      Daniel J. Priem
 `. `'       http://flexserv.de
   `-        

