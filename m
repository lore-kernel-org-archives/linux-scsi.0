From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.16-rc1-mm2
Date: Fri, 27 Jan 2006 09:53:13 -0500
Message-ID: <43DA33D9.5080701@pobox.com>
References: <20060120031555.7b6d65b7.akpm@osdl.org> <986ed62e0601211045p4a61a7c2v91d401af86f50d6@mail.gmail.com> <200601211636.24693.edt@aei.ca> <200601230739.45525.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:37310 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751259AbWA0Ox1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 09:53:27 -0500
In-Reply-To: <200601230739.45525.edt@aei.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: "Barry K. Nathan" <barryn@pobox.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com, linux-scsi@vger.kernel.org

Ed Tomlinson wrote:
> Summarizing all this.  There are two problems here.
> 
> 1. reserifs4 panics when it gets io errors - I remember this was an issue that
> needed to be fixed in the R4 code before it moves to mainline...
> 
> 2. Why does a drive which is fine with 2.6.15-rc5-mm3, return a -5 with 2.6.16-mm3
> and above?  Smart reports no problems with the drive hardware.  What has changed 
> in the libata/scsi stacks?

That's a long answer.  Could you assist in narrowing down the versions 
which are affected?

It would also be useful if you could try vanilla kernels, and help us 
discover whether problems surfaces in 2.6.15, 2.6.15-git[1234], 
2.6.16-rc1, etc.

	Jeff



