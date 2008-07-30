From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Date: Wed, 30 Jul 2008 15:50:04 -0400
Message-ID: <4890C5EC.70305@torque.net>
References: <Pine.LNX.4.44L0.0807301016010.2584-100000@iolanthe.rowland.org> <1217429722.3335.3.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:57159 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbYG3TuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 15:50:21 -0400
In-Reply-To: <1217429722.3335.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>

James Bottomley wrote:
> On Wed, 2008-07-30 at 10:17 -0400, Alan Stern wrote:
>> On Tue, 29 Jul 2008, Matthew Dharm wrote:
>>
>>> Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
>>> just become a sysfs parameter which defaults to the 'ignore' state...
>> We have to be careful; there definitely are devices out there which 
>> need to use the Residue.
> 
> This is sort of a tradeoff ... there was one complaint I saw where a
> device turned read only without the fix idenitifed in this report.
> Devices broken by the fix are definitely crawling out of the woodwork
> now.  Either this patch needs to be reverted or a new fix needs to be
> applied soon (and to stable).

The patches to fix this that I have tried do not apply
cleanly to lk 2.6.26 (and break during compile if forced:
"us->fflags" is not defined).

Is there a lk 2.6.26 patch available?

Doug Gilbert
