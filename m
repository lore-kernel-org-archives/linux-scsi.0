From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Tue, 21 Feb 2012 23:55:32 +0200
Message-ID: <CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
	<1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60553 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab2BUVzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 16:55:33 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id u2so8174602lag.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2012 13:55:32 -0800 (PST)
In-Reply-To: <1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On Mon, Feb 13, 2012 at 3:00 PM, <vikas.chaudhary@qlogic.com> wrote:
> Added ping support for iscsi adapter, application can use this
> interface for diagnostic network connection.

Could you elaborate a little further on the motivation here? what's
the difference between the pings you're suggesting to the initiator
initiated iscsi NOPs which are fully supported by the current
initiator stack?

Or.
