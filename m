From: "George Spelvin" <linux@horizon.com>
Subject: Re: [Bug 19642] 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: 4 Oct 2010 21:24:23 -0400
Message-ID: <20101005012423.31548.qmail@science.horizon.com>
References: <1286237419.18417.306.camel@haakon2.linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:51636 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756118Ab0JEBYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2010 21:24:25 -0400
In-Reply-To: <1286237419.18417.306.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org, linux@horizon.com, linux-scsi@vger.kernel.org

> Would you be able to 'git bisect' on your system with Linus'es
> linux-2.6.git tree from commit 9fe6206f400646a (v2.6.35) to HEAD at
> v2.6.36-rc6 to help us pinpoint which commit the breakage was
> introduced..?

It's tedious, but I can, HOWEVER...
any advice avoiding false positives from
https://bugzilla.kernel.org/show_bug.cgi?id=16275
introduced in 74450be123b6f3cb480c358a056be398cce6aa6e
and fixed in 2c7d46ec192e4f2b350f67a0e185b9bce646cd6b?

I suppose I could cherry-pick the latter when in the
vulnerable range...
