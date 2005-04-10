From: sai narasimhamurthy <sai_narasi@yahoo.com>
Subject: increasing scsi_max_sg / max_segments for scsi writes/reads
Date: Sat, 9 Apr 2005 19:35:52 -0700 (PDT)
Message-ID: <20050410023552.2545.qmail@web54101.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web54101.mail.yahoo.com ([206.190.37.236]:18364 "HELO
	web54101.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261275AbVDJCfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Apr 2005 22:35:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi, 
I had posted a question on increasing the scsi
read/write sectors  per command. I figured out some of
the things, but many questions still exist. 

I was wondering why the maximum writes I could get
from a single scsi write command could never exceed
204 
4096B  segments . I traced it to :  

static const int scsi_max_sg = PAGE_SIZE /
sizeof(struct scatterlist)

in scsi_merge.c .(which amounts to 204)  

Is this the limit of the maximum blocks we can
read/write through a single scsi command, atleast for
the given kernel (2.4.29) ? How can I increase
it??????

I am on a P3 Dell poweredgde 2400 . 

Sai 

  










__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
