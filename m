From: "Joe Pearson" <joe@webdms.com>
Subject: Ordered tag forced
Date: Tue, 8 Oct 2002 15:50:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00a701c26f1d$21c9c040$13a8a8c0@webdms.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've been getting "ordered tag forced" messages in our log file and after
reading a few post here, I was beginning to think they were nothing to worry
about.  However, recently we started getting a message several times a day
that looks like the drive is resetting.  Is this something to worry about?
Is the drive resetting?


Oct  6 15:49:30 tiger kernel: sym53c896-1-<0,0>: ordered tag forced.
Oct  6 15:55:43 tiger kernel: sym53c896-1-<0,0>: ordered tag forced.
Oct  6 16:31:59 tiger kernel: sym53c896-1-<0,0>: ordered tag forced.
Oct  6 16:31:59 tiger kernel: sym53c896-1-<0,*>: FAST-40 WIDE SCSI 80.0 MB/s
(25
.0 ns, offset 31)

Anyone have any thoughts?

Thanks,
Joe Pearson

