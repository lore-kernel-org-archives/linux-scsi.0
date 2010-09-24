From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Thu, 23 Sep 2010 19:51:48 -0500
Message-ID: <4C9BF624.7090906@hardwarefreak.com>
References: <4C9BE5A8.1090002@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C9BE5A8.1090002@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord put forth on 9/23/2010 6:41 PM:
> What's the purpose of this stack dump,
> and how can it be prevented in this NORMAL situation??
> 
> The command was "hdparm --security-erase NULL /dev/sdb",
> which takes about 66 minutes to complete on this particular drive.
> 
> I don't see any obvious way for the task to mark itself
> as needing longer than 120 secs to complete the operation.

~$ man hdparm

ATA Security Feature Set

These switches are DANGEROUS to experiment with,
and might not work with every kernel. USE AT YOUR OWN RISK.

--security-erase PWD

THIS FEATURE IS EXPERIMENTAL AND NOT WELL TESTED.  USE  AT  YOUR
              OWN RISK.

-- 
Stan
