From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [REGRESSION][v4.13.y][v4.14.y] scsi: libsas: allow async aborts
Date: Thu, 16 Nov 2017 17:08:05 -0500
Message-ID: <27d1c9b1-9a80-4982-290b-3916d6e5c80f@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: hch@lst.de
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hare@suse.de, jthumshirn@suse.de, bart.vanassche@wdc.com, bblock@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jth@kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org, 1726519@bugs.launchpad.net
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

909657615d9b ("scsi: libsas: allow async aborts")

     
The regression was introduced as of v4.12-rc1, and it still exists in
4.14 mainline.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?

   
Thanks,
   
Joe

[0] http://pad.lv/1726519
