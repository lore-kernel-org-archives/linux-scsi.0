From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: command failing at iSCSI disconnect
Date: Sun, 16 Sep 2007 02:56:04 +0900
Message-ID: <20070914184534G.tomof@acm.org>
References: <46EB008F.7040003@mvista.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49748 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbXIOR4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 13:56:17 -0400
In-Reply-To: <46EB008F.7040003@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djiang@mvista.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 14 Sep 2007 14:43:43 -0700
Dave Jiang <djiang@mvista.com> wrote:

> I'm using the latest linus git tree. This is in fileio mode with
> IOMode=wb. It seems that if I do I/O and then immediately disconnect
> then the cache sync commands fail. Is this expected behavior or should
> the connection wait till all existing commands has been flushed before
> logout? Thanks!
> 
> root@192.168.1.171:~/iscsi2# iscsiadm -m node -T
> iqn.2007.com.mvista:disk1 -p 192.168.1.239:3260 --logout
> Logout session [sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> sid: 1, target: iqn.2007.com.mvista:disk1, portal: 192.168.1.239,3260]
> iscsi: cmd 0x35 is not queued (6)
> iscsi: cmd 0x35 is not queued (6)
> iscsi: cmd 0x35 is not queued (6)
> sd 1:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00

I think that the fix is in Mike's iscsi git tree.

It would be better to ask at open-iscsi mailing list.
