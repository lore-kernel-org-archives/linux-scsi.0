From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [PATCH][v3.18.y][3.19.y-ckt][4.0.y] storvsc: Set the SRB flags correctly
 when no data transfer is, needed
Date: Fri, 05 Jun 2015 13:51:24 -0400
Message-ID: <5571E19C.9000202@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: sasha.levin@oracle.com, Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: KY Srinivasan <kys@microsoft.com>, longli@microsoft.com, JBottomley@Odin.com, alexng@microsoft.com, Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,
    
Please consider including mainline commit
dc45708ca9988656d706940df5fd102672c5de92 in the next v3.18.y, v4.0.y and
3.19.y-ckt stable releases.  It was
included in the mainline tree as of v4.1-rc5.  It has been tested and
confirmed to resolve the following bug:
http://bugs.launchpad.net/bugs/1439780
 
commit dc45708ca9988656d706940df5fd102672c5de92
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Fri May 1 11:03:02 2015 -0700

    storvsc: Set the SRB flags correctly when no data transfer is needed



Sincerely,

Joseph Salisbury
