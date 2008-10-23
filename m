From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Possible bug in SCSI Kconfig
Date: Thu, 23 Oct 2008 20:59:53 +0200
Message-ID: <4900C9A9.7010104@s5r6.in-berlin.de>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com> <1224702340.6851.20.camel@localhost.localdomain> <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <1224704659.6851.28.camel@localhost.localdomain> <4900B4B9.4050103@s5r6.in-berlin.de> <20081023173917.GP26094@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43509 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbYJWTAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 15:00:01 -0400
In-Reply-To: <20081023173917.GP26094@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Fabio Comolli <fabio.comolli@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Thu, Oct 23, 2008 at 07:30:33PM +0200, Stefan Richter wrote:
>>   - scsi_wait_scan is a special method to wait for devices during boot
>>     which only works with some hardware types.  More general methods are
>>     available and have been in use far longer than scsi_wait_scan
>>     exists.  Nobody fundamentally needs scsi_wait_scan, it is only a
>>     convenient tool for some users who choose to use it.
>>     Special features are traditionally per default off in Kconfig and
>>     are supposed to be actively enabled.
> 
> What 'general methods' would those be?

Waiting for the desired numbers of devices to show up.  Or for a known 
device.

scsi_wait_scan is optimal though if it is known at the outset how many 
devices (or how many at maximum) will show up.
-- 
Stefan Richter
-=====-==--- =-=- =-===
http://arcgraph.de/sr/
