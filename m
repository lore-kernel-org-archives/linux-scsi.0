From: Sean Neakums <sneakums@zork.net>
Subject: Re: Crashing problems with Neuros USB Device
Date: Fri, 25 Jul 2003 21:19:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6uptjy1hrd.fsf@zork.zork.net>
References: <20030725191853.GB3699@bostoncoop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zork.zork.net ([64.81.246.102]:4775 "EHLO zork.zork.net")
	by vger.kernel.org with ESMTP id S272281AbTGYUEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 16:04:25 -0400
In-Reply-To: <20030725191853.GB3699@bostoncoop.net> (Adam Kessel's message
 of "Fri, 25 Jul 2003 15:18:53 -0400")
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adam Kessel <adam@bostoncoop.net> writes:

> Finally, I frequently get: 
>
> kernel: kernel BUG at drivers/block/as-iosched.c:1600!  
>
> in 2.6.

This may have nothing to do with anything, and this completely off the
top of my head, but that message looks like it's from the anticipatory
scheduler.  To eliminate AS as the culprit on 2.6, you can switch to
the deadline scheduler by booting with elevator=deadline.

