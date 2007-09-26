From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 10:28:00 +0900
Message-ID: <20070925065233Q.tomof@acm.org>
References: <1190768402.8707.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50988 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXIZB2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 21:28:14 -0400
In-Reply-To: <1190768402.8707.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 25 Sep 2007 20:00:02 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> Andrew asked that I provide a status report of pending updates.  The
> list is attached below.  It's pretty much driver updates and minor bug
> fixes.  The main functionality changes are Kay's sysfs updates and the
> shift of the ULD attachement towards the block prep function.

Can we make new 'supporrted_mode' and 'active_mode' attributes look
better?

http://marc.info/?l=linux-scsi&m=118991196128245&w=2
