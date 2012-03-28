From: Andy Grover <agrover@redhat.com>
Subject: vaai/xcopy features in LIO (was Re: Vmware ESXi5 Build 623860 - UNMAP
 Bit)
Date: Wed, 28 Mar 2012 10:12:23 -0700
Message-ID: <4F734677.7090102@redhat.com>
References: <20120327122630.GA11806@mail.brockz.de> <20120327124244.GA11944@mail.brockz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596Ab2C1RM2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2012 13:12:28 -0400
In-Reply-To: <20120327124244.GA11944@mail.brockz.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Gourguis <brockz@cloudmate.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/27/2012 05:42 AM, Stefan Gourguis wrote:
> Me again....
> 
> is disabling the VAAI on ESXi the only Solution to fix this ?
> Is there a VAAI Support planned for the Community Edition of LIO?

I'd certainly like to see the unmap stuff, don't know about the locking
stuff. I think there was a question over whether to support extended
copy as-is or support an xcopy-lite that may be in the works.

I thought esx was supposed to detect support and only use it if present
(gleaned from watching marketing videos on youtube), it's not
automatically disabling it, then?

-- Andy
