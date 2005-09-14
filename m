From: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: 2.6.13-mm3 and 2.6.14-rc1 both broken (SCSI?)
Date: Wed, 14 Sep 2005 07:32:29 -0700
Message-ID: <319880000.1126708349@[10.10.2.4]>
References: <20050728025840.0596b9cb.akpm@osdl.org>
Reply-To: "Martin J. Bligh" <mbligh@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965218AbVINOca@vger.kernel.org>
In-Reply-To: <20050728025840.0596b9cb.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Heh, when I said "wheeeeeee - it all works" (with flip fixes) ... 
I spoke too soon.

It's now broken in both -mm3 and -git 
Some scsi problem on one of hte power boxes:

http://test.kernel.org/12729/debug/console.log

Attached scsi disk sdb at scsi0, channel 0, id 9, lun 0
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
sdc: Spinning up disk....<6> target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)

( ... repeated forever)

2.6.13-git11 worked.
