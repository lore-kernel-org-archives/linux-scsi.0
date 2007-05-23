From: Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: [Stgt-devel] Question about the basic concept of SCSI layer
	and Block layer
Date: Wed, 23 May 2007 10:00:18 -0400
Message-ID: <1179928818.3847.5.camel@dhcp-136.ibrix.com>
References: <4104961b0705230653y26d0f6f9k92c56d6d913b5d8f@mail.gmail.com>
	 <4104961b0705230655j32ae30f9p78b7f7d906a92a92@mail.gmail.com>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:63185 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbXEWOAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 10:00:21 -0400
Received: by wx-out-0506.google.com with SMTP id t15so195435wxc
        for <linux-scsi@vger.kernel.org>; Wed, 23 May 2007 07:00:21 -0700 (PDT)
In-Reply-To: <4104961b0705230655j32ae30f9p78b7f7d906a92a92@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidong xiao <jidong.xiao@gmail.com>
Cc: stgt-devel@lists.berlios.de, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Wed, 2007-05-23 at 21:55 +0800, jidong xiao wrote:
> Hi,All,
>   I have a question, what's the relationship between SCSI layer and
> Block layer?I remember initially there are three types of device
> drivers, say, char device driver, block device driver, network device
> driver, so there is a directory "drivers/block",but recent years,most
> part of the code for block devices have been moved out of the
> directory drivers/block, but there is still a block I/O layer, so I am
> wondering what's the relationship between Block layer and other
> subsystem, like how to connect block layer and filesystem(VFS or the
> actually file system), how to bridge it with scsi layer, for example,
> the scsi disk driver, sd.o. Who can please kindly explain this for me,
> thank you very much!


u had better send these questions to kernel newbie or scsi list. the
other 2 you included are not related at all.

> 
> Best Regards
> Jason
> _______________________________________________
> Stgt-devel mailing list
> Stgt-devel@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/stgt-devel

