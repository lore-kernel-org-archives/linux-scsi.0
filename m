From: taco <tacoee@gmail.com>
Subject: Re: kernel cant access SATA adapter device
Date: Thu, 24 Oct 2013 00:09:17 +0800
Message-ID: <20131023160916.GA24189@taco-ThinkPad-X220>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
 <20131017155924.GA31331@taco-ThinkPad-X220>
 <20131017130249.4a49bd46@kvm171.vb.futz.org>
 <20131018143745.GA2615@taco-ThinkPad-X220>
 <20131018145321.3d60711b@kvm171.vb.futz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40759 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3JWQJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 12:09:26 -0400
Received: by mail-pb0-f47.google.com with SMTP id rq2so955179pbb.6
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 09:09:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131018145321.3d60711b@kvm171.vb.futz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Story <rstory@tislabs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Sense key [02 04 02] means LOGICAL UNIT NOT READY, INITIALIZING COMMAND REQUIRED

it works on windows but not on linux?

On Fri, Oct 18, 2013 at 02:53:21PM -0400, Robert Story wrote:
> On Fri, 18 Oct 2013 22:37:45 +0800 taco wrote:
> T> 
> T> reproduce the problem with more debug messages with the bellow
> T> command:
> T> 
> T> $ echo 0x2FFFF > /sys/modules/mptsas/mpt_debug_level
> T> 
> T> and attach it here
> 
> The dmesg buffer wrapped, and it was close to 500k. That's a bit big for
> sending to the whole list, so I put it and the syslog output on my
> webserver:
> 
>    http://futz.org/users/linux-scsi/mpt.messages
>    http://futz.org/users/linux-scsi/mpt.dmesg 
> 
> 
> Robert
> 
> --
> Senior Software Engineer
> Parsons Government Services , National Security & Defense Division


