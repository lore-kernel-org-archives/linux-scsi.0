From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/3] iscsi: fix setting of pid from netlink skb
Date: Fri, 27 Jan 2012 08:04:58 +0100
Message-ID: <CAO+b5-o8GoYaTx=c9E+8vDJdkDR53YceUCQTu+VSpO9ZUeL6iA@mail.gmail.com>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
	<1327633991-2615-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45362 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2A0HE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2012 02:04:59 -0500
Received: by wics10 with SMTP id s10so976733wic.19
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2012 23:04:58 -0800 (PST)
In-Reply-To: <1327633991-2615-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 27, 2012 at 4:13 AM, <michaelc@cs.wisc.edu> wrote:
> NETLINK_CREDS's pid now returns 0, so I guess we are supposed to
> be using NETLINK_CB. This changed while the patch to export the
> pid was getting merged upstream, so it was not noticed until both
> the network and iscsi changes were in the same tree.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

If my analysis is correct this patch has not only to be applied on the
master branch but also on kernel 3.2. Shouldn't "Cc:
stable@vger.kernel.org #3.2" be added here ? See also
http://www.spinics.net/lists/netdev/msg185565.html.

Bart.
