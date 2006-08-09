From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCHSET] qla4xxx: more qla4xxx cleanup
Date: Wed, 09 Aug 2006 13:24:06 -0500
Message-ID: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:11187 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751313AbWHISqv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 14:46:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Howdy!

The following 3 patch series implements some more qla4xxx cleanup,
which should the the last of these in the one file.

Shortlog:
Doug Maxey:
      qla4xxx: clarify doc for probe_adapter
      qla4xxx: really move free_adapter
      qla4xxx: iospace_config move defn

Diffstats:
 drivers/scsi/qla4xxx/ql4_os.c |  203 ++++++++++++++++++++---------------------
 1 files changed, 99 insertions(+), 104 deletions(-)

---

I really do believe this is the last of the code churn in ql4_os.c.  I
lose track of where I am sometimes, and changes get left behind.  :)

Oh, and hopefully I learned enough about stgit to have the following
patches be replies to this one.  Eike pointed out that last set was
not a reply to the cover letter.  Apparently you cannot save a cover,
edit it, and then send it and have the patches be replies.  At least
not the way I did it.  The message-id generated and used in the patch
mail was not the one in the saved cover letter, so the replies were to
a non-existant (at least on the recipient) message-id.

--

The next series will implement the iscsi specific printk changes
requested by Mike.

--
++doug
