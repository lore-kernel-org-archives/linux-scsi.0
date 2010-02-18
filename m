From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries 330
Date: Wed, 17 Feb 2010 19:29:44 -0800
Message-ID: <86802c441002171929p1939680au492934badf5ccc19@mail.gmail.com>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
	 <201002180320.o1I3KhQU031006@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50342 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0BRD3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 22:29:46 -0500
Received: by pwj8 with SMTP id 8so1348745pwj.19
        for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2010 19:29:45 -0800 (PST)
In-Reply-To: <201002180320.o1I3KhQU031006@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

please check if

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=18dce6ba5c8c6bd0f3ab4efa4cbdd698dab5c40a

fix the problem.

Yinghai
