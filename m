From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: max GiB written per boot
Date: Tue, 7 Oct 2003 15:12:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007151225.0a65dcb7.rddunlap@osdl.org>
References: <1064271322.4797.9.camel@patehci2>
	<1064847281.24854.2.camel@patehci2>
	<1064850600.25057.7.camel@patehci2>
	<20030929164654.GS15415@suse.de>
	<1064855570.3184.3.camel@patehci2>
	<1064865746.4262.63.camel@patehci2>
	<1065460336.10804.1.camel@patehci2>
	<1065474044.6835.44.camel@patehci2>
	<1065484077.2899.1.camel@patehci2>
	<20031007055714.GO972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:53985 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262930AbTJGWVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 18:21:09 -0400
In-Reply-To: <20031007055714.GO972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: p.lavarre@ieee.org, linux-scsi@vger.kernel.org

On Tue, 7 Oct 2003 07:57:14 +0200 Jens Axboe <axboe@suse.de> wrote:

| > 
| > Having hdc=ide-scsi matter I think is a clue.
| > 
| > I don't yet know if this apparent correlation will hold up or not.
| 
| Yeah, ide-scsi is broken so you probably shouldn't be using it.

Is there any sense in trying to repair it?
I could spend some time on it...

--
~Randy
