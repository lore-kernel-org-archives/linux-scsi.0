From: Luben Tuikov <ltuikov@yahoo.com>
Subject: LLDD: scatterlists only?
Date: Sun, 14 Aug 2005 16:24:46 -0700 (PDT)
Message-ID: <20050814232446.58676.qmail@web51604.mail.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51604.mail.yahoo.com ([206.190.38.209]:56499 "HELO
	web51604.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932345AbVHNXYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 19:24:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Did someone have a patch or was there a talk
that SCSI Core is moving towards sending _only_ scatterlists
down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))

	Luben

