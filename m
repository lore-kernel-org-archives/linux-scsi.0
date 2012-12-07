From: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: Slow writes to SAS drives on LSI mpt2sas HBA
Date: Thu, 6 Dec 2012 20:43:38 -0500
Message-ID: <450090F8-2B0F-4B38-AB7C-2154C75043F9@gmail.com>
References: <536E46D8-A041-4860-A922-21305CAF5321@gmail.com> <1354572400.4420.66.camel@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62093 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2LGBnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 20:43:03 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so91142qad.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Dec 2012 17:43:02 -0800 (PST)
In-Reply-To: <1354572400.4420.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

Hello Ewan

On Dec 3, 2012, at 5:06 PM, Ewan Milne <emilne@redhat.com> wrote:

>> 
> 
> It sounds like your drive write cache is disabled, 7200RPM is 120
> revolutions/sec, and you are getting 7747584 / 1024 / 63.59 = ~119 IO/s
> I believe the write cache is enabled by default on SATA drives, which
> would explain the difference.

You were exactly right.  Thank you!

A quick "sdparm -S -set=WCE <dev>" and I was back to where I expected.

Thanks again,
-Greg
