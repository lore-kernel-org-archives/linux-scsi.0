From: Matthew Wilcox <willy@debian.org>
Subject: Which tag constants to use?
Date: Sun, 19 Sep 2004 06:33:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040919053310.GH642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56977 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269667AbUISFdK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Sep 2004 01:33:10 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C8uJy-00087o-8q
	for linux-scsi@vger.kernel.org; Sun, 19 Sep 2004 06:33:10 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Now that I've decided to ditch all the BSD compatibility code from sym2,
I'm looking at converting the constant names to the standard Linux ones.
Here's an interesting part of that -- we have two different Linux names
for tag messages:

<scsi/scsi_tcq.h>:
#define MSG_SIMPLE_TAG  0x20
#define MSG_HEAD_TAG    0x21
#define MSG_ORDERED_TAG 0x22

<scsi/scsi.h>:
#define SIMPLE_QUEUE_TAG    0x20
#define HEAD_OF_QUEUE_TAG   0x21
#define ORDERED_QUEUE_TAG   0x22

I presume the tcq ones are newer and hence should be used in preference?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
