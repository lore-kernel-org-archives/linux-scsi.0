From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 8 Jul 2009 15:09:44 +0200
Message-ID: <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60690 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZGHNJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 09:09:46 -0400
In-Reply-To: <20090702130728.22af524c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Similar issue on 2 machines. 2.6.31-rc1-git3 works ok. 2.6.31-rc2
cannot recognize *any* DVD media with K3b. No messages in dmesg or
syslog.

Unfortunately I can't try bisection, because I don't have more time
(work). I try do it at the end of week.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
