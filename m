From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 12:45:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC51595.2030801@pobox.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC5135F.50803@pobox.com> <20030516164003.GI812@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47050 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264487AbTEPQch
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:32:37 -0400
In-Reply-To: <20030516164003.GI812@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> Aha, and how do you wrap an ata command nicely into a scsi cdb? I can
> only see it getting ugly.

With 16-byte cdbs it's doable.  With 12-byte it's not.


> Irk! I can't believe you are suggesting something like this. Jeff,
> please do yourself a favor and think about what you are saying for a
> second.


I have.  :)  I think you're missing the additional complexity of doing 
it any other way...

	Jeff


