From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 25/33] Fix the reproducible oops in scsi
Date: Tue, 06 Feb 2007 15:21:00 -0500
Message-ID: <45C8E32C.7080402@emulex.com>
References: <200702060040.l160e04u005027@shell0.pdx.osdl.net>	<1170775326.3634.14.camel@mulgrave.il.steeleye.com> <20070206113942.afbc019b.akpm@linux-foundation.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64711 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbXBFUVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2007 15:21:16 -0500
In-Reply-To: <20070206113942.afbc019b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, hirofumi@mail.parknet.co.jp

Hannes and I will be fostering discussion at the upcoming IO summit
to discuss options.

-- james s

Andrew Morton wrote:
> On Tue, 06 Feb 2007 09:22:06 -0600
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
>> On Mon, 2007-02-05 at 16:38 -0800, akpm@linux-foundation.org wrote:
>>> From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>>>
>>> I got the oops after some hotplug events. And the similar oops can
>>> reproduce by the following step.
>> James Smart already pointed out that this fix isn't valid ... it's a
>> bandaid that doesn't fix the underlying problem.
>>
> 
> That's why I included his comments in the changelog.
> 
> Is anyone going to fix it for real?  Do we know _how_ it should be fixed?
> 
