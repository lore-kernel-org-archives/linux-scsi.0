From: Dan Carpenter <error27@gmail.com>
Subject: aacraid drops offline w/ opteron and 16G of RAM (2.6.9)
Date: Tue, 7 Dec 2004 10:59:14 -0800
Message-ID: <a63d67fe0412071059323f0900@mail.gmail.com>
Reply-To: Dan Carpenter <error27@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261229AbULHO2V@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dackerman@penguincomputing.com
List-Id: linux-scsi@vger.kernel.org

I'm using an Adaptec 2200S RAID card in an opteron system.  It works fine 
if I use 12G of RAM but if I have 16G it drops offline under stress (bonnie++ 
etc).  Basically it's as if the whole array has been removed.

I first saw this problem under the suse9.1 2.6.5 kernel but the
problem is still
there under the 2.6.9 kernel as well.

I've tested the hardware, and this has happenned on 2 seperate systems so
it's not a hardware component problem.

Based on history with different RAID cards, I tried turning off node interleave
and harddware IOMMU on the Arima motherboard, but that hasn't made a 
difference.

Has anyone seen this problem before?

regards,
dan carpenter
