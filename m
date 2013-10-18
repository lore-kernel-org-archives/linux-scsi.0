From: taco <tacoee@gmail.com>
Subject: Re: kernel cant access SATA adapter device
Date: Fri, 18 Oct 2013 22:37:45 +0800
Message-ID: <20131018143745.GA2615@taco-ThinkPad-X220>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
 <20131017155924.GA31331@taco-ThinkPad-X220>
 <20131017130249.4a49bd46@kvm171.vb.futz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60190 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3JROhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2013 10:37:53 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so2493714pdi.4
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2013 07:37:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131017130249.4a49bd46@kvm171.vb.futz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Story <rstory@tislabs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


reproduce the problem with more debug messages with the bellow
command:

$ echo 0x2FFFF > /sys/modules/mptsas/mpt_debug_level

and attach it here


On Thu, Oct 17, 2013 at 01:02:49PM -0400, Robert Story wrote:
> On Thu, 17 Oct 2013 23:59:24 +0800 taco wrote:
> T> What is the version of mptsas driver?
> 
> modinfo mptsas reports verion 3.04.20. Kernel is 2.6.32-358 (RHEL 6.3).
> 
> T> It seems that the mptsas's driver can't recognize the the type of SD
> T> card and treat it as normal hard disk drive.
> 
> Ok. So how would I figure out what mptsas is looking at to determine how to
> treat it? Or is there some kernel param I can pass that says sda=sdcard or
> soemthing?
> 
> 
> Robert
> 
> --
> Senior Software Engineer
> Parsons Government Services , National Security & Defense Division


