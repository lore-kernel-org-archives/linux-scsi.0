From: Byron Stanoszek <gandalf@winds.org>
Subject: RE: PATCH: Further aacraid work
Date: Wed, 30 Jun 2004 15:52:46 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406301549590.30468@winds.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D6EE@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from winds.org ([68.75.195.9]:50072 "EHLO winds.org")
	by vger.kernel.org with ESMTP id S261987AbUF3Twx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 15:52:53 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D6EE@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, Alan Cox <alan@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 29 Jun 2004, Salyzyn, Mark wrote:

> Oooo, good!
>
> The Adapter has declared itself `dead' (maybe for reasons other than a
> controlled blinkLED situation). Effectively a crash or complete loss of
> communications with the Adapter. Last time I've seen this happened it
> was a bad power supply.
>
> Contact technical support to have them narrow down the actual cause of
> adapter failure ... I don't know where the F/W updates are held on the
> Dell Site.

I was able to upgrade the firmware to build 6089 and everything works
flawlessly now. I'm currently using your aacraid-1.1.5-2345 driver and things
haven't complained once. I also haven't had a problem with Alan's aacraid
driver on my development server, which is running Perc 3/Si fw 2951.

So Perc 2/Si fw 2939 must be buggy, all there is to it. :)

Anyways, thanks for your quick help! I'll let you know if anything else goes
wrong.

  -Byron

--
Byron Stanoszek                         Ph: (330) 644-3059
Systems Programmer                      Fax: (330) 644-8110
Commercial Timesharing Inc.             Email: byron@comtime.com
