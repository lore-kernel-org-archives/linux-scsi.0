From: Alain Kalker <a.c.kalker@gmail.com>
Subject: Re: [PATCH] sd: Reduce log level to KERN_NOTICE for missing caching
 mode page
Date: Mon, 02 Jun 2014 13:51:04 +0200
Message-ID: <538C6528.5030504@gmail.com>
References: <1401706006-7914-1-git-send-email-a.c.kalker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37437 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFBLvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 07:51:11 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so4159564wib.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 04:51:07 -0700 (PDT)
Received: from [192.168.1.157] (524B772B.cm-4-4b.dynamic.ziggo.nl. [82.75.119.43])
        by mx.google.com with ESMTPSA id f2sm31944395wiz.11.2014.06.02.04.51.05
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 02 Jun 2014 04:51:05 -0700 (PDT)
In-Reply-To: <1401706006-7914-1-git-send-email-a.c.kalker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 06/02/2014 12:46 PM, Alain Kalker wrote:
> Reduce the lernel log level to KERN_NOTICE for messages related
> to a missing caching mode page.
>
> Reasons why I think this change is justified:
> - The condition is non-fatal; the existing workaround assumes
>    a write through cache. Although this reduces write performance,
>    it doesn't limit functionality in any way.
> - The current log level suggests that immediate action is
>    required, however, as it is a hardware limitation, there is
>    nothing much the user can do about it besides replacing the
>    affected hardware.
whoops, confused that one with KERN_ALERT, sorry about that.

Will reword, rebase and repost.
> - The current situation breaks quiet boot (kernel commandline
>    parameter 'quiet'), and may trip log monitoring software
>    unneccessarily, either on every boot or whenever an affected
>    external device is plugged in.
>
> Signed-off-by: Alain Kalker <a.c.kalker@gmail.com>

