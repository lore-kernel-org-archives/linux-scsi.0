From: denebeim@deepthot.org (Jay Denebeim)
Subject: coding style question
Date: Wed, 25 Feb 2004 18:16:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c1ioqg$6ae$1@dent.deepthot.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deepthot.org ([68.14.232.127]:37028 "EHLO dent.deepthot.org")
	by vger.kernel.org with ESMTP id S261527AbUBYSQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 13:16:49 -0500
Received: from news by dent.deepthot.org with local (Exim 4.30)
	id 1Aw3aS-0001hD-2o
	for linux-scsi@vger.kernel.org; Wed, 25 Feb 2004 11:16:48 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've noticed that in 2.6 many of the constructs like:

typedef struct foo { blah }

have been changed to 

struct foo { blah }

what was the reasoning for this?

Thanks
Jay
-- 
* Jay Denebeim  Moderator       rec.arts.sf.tv.babylon5.moderated *
* newsgroup submission address: b5mod@deepthot.org                *
* moderator contact address:    b5mod-request@deepthot.org        *
* personal contact address:     denebeim@deepthot.org             *
