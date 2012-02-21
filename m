From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/11] iscsi_transport: Added Ping support
Date: Tue, 21 Feb 2012 16:33:41 -0600
Message-ID: <4F441BC5.4000301@cs.wisc.edu>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>	<1329138050-1042-10-git-send-email-vikas.chaudhary@qlogic.com> <CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41220 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab2BUWdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 17:33:17 -0500
In-Reply-To: <CAJZOPZLdXtdLyTstWLu8A1Q454LD4k-0+HoDdqEHwFzbs+Ro6g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: vikas.chaudhary@qlogic.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On 02/21/2012 03:55 PM, Or Gerlitz wrote:
> On Mon, Feb 13, 2012 at 3:00 PM, <vikas.chaudhary@qlogic.com> wrote:
>> Added ping support for iscsi adapter, application can use this
>> interface for diagnostic network connection.
> 
> Could you elaborate a little further on the motivation here? what's
> the difference between the pings you're suggesting to the initiator
> initiated iscsi NOPs which are fully supported by the current
> initiator stack?

This is network based. ICMP pings. The stuff we have today is iscsi
based pings.

So you can do some basic network diag type of stuff.
