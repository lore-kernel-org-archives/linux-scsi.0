From: "Jack Wang" <jack_wang@usish.com>
Subject: [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Date: Fri, 17 Sep 2010 18:11:56 +0800
Message-ID: <3219F4D1734640238A632382C50F633E@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

Hi all

I update kernel to 2.6.36rc4 to test our driver, and found rmmod
pm8001 will cause system crash, then I rollback to 2.6.35.4 the driver
works as expected. Could someone any some hints for this? I'll give more
detailed messages if needed on Monday.

Thanks.
Jack
