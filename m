From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Mon, 21 May 2012 22:41:43 +0800
Message-ID: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
References: <1337269686-3781-3-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52769 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2EUOlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 10:41:44 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
[snip]
> I may have left some parts out from this brief description. =A0Hopefu=
lly
> you'll be able to figure out the general idea and get it to work.

All journal threads and flusher thread of the disk need to be freezed
before suspend and thaw after resume.

>
> Alan Stern
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
