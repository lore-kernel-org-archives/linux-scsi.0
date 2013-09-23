From: Akinobu Mita <mita@fixstars.com>
Subject: Re: [PATCH] ufs: adjust queue settings to PRDT limitations
Date: Tue, 24 Sep 2013 07:42:14 +0900
Message-ID: <CAD7r0yB9nynQ7RRcELy7QcL=xYTG3_tFzWh6oOUWuaaDKCWEYw@mail.gmail.com>
References: <1379745419-7099-1-git-send-email-mita@fixstars.com>
	<523FF231.7080300@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:42664 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3IWWqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 18:46:05 -0400
In-Reply-To: <523FF231.7080300@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

> Ideally there should be comment here to explain the reason for this limitation. I see comments in commit text but not here in code.
> Its not general practice to browse through history to understand the reason behind this limitations. so it always helps to add comments in code itself.

OK, I'll update the patch with the comment.
