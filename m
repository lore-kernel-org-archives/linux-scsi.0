From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: mvsas with 3.1 (mdraid+xfs locked up, single drive w/xfs not
 locked up)
Date: Tue, 17 Jan 2012 11:55:41 +0800
Message-ID: <4F14F13D.2000407@fnarfbargle.com>
References: <201201131144.58044.thomas@fjellstrom.ca> <201201162000.54940.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fnarfbargle.com ([93.93.131.224]:41049 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855Ab2AQDz5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2012 22:55:57 -0500
In-Reply-To: <201201162000.54940.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>

On 17/01/12 11:00, Thomas Fjellstrom wrote:
>
> Here's something interesting though, I just tried writing to the one disk on
> the card that isn't part of the mdraid raid5 volume. It is fine. I can read
> from it and write to it. So something to do with mdraid, or the XFS filesystem
> (or both) is causing a bad interaction with the card itself.

Try doing IO to multiple drives simultaneously. I had a SIL card that would corrupt data when used 
in RAID, but not single drive IO tests. I could make it fail by doing multiple dd/cp/md5sum to two 
drives simultaneously.

Do yourself a favour. Whack it on fleabay and sell it to a Windows user, then get something 
supported. Leave enough scatter around that people thinking of buying a card with that Marvell 
chipset will stay clear.

Regards,
Brad
