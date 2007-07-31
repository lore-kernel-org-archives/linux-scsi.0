From: Petr Vandrovec <petr@vandrovec.name>
Subject: Re: Inclusion of vmware mptbase regression fix
Date: Tue, 31 Jul 2007 14:48:45 -0700
Message-ID: <46AFAE3D.7000109@vandrovec.name>
References: <20070731202402.63f55ae5@localhost> <1185914967.3468.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw.cvut.cz ([147.32.3.235]:47536 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760556AbXGaVud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 17:50:33 -0400
In-Reply-To: <1185914967.3468.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Maarten Bressers <info@mbressers.speedlinq.nl>, dsd@gentoo.org, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-07-31 at 20:24 +0200, Maarten Bressers wrote:
>> Hi Petr,
>>
>> The patch you posted for the MPT Fusion driver regression with VMware 
>> 5.5.4 (http://lkml.org/lkml/2007/3/23/345) was used to fix a Gentoo 
>> kernel bug (http://bugs.gentoo.org/show_bug.cgi?id=185272).
>>
>> Have you received word from upstream (kernel devs) yet as to whether 
>> your patch will be included? Or if it will be included at all?
> 
> That's a slightly worse version of this patch.
> 
> http://marc.info/?l=linux-scsi&m=117432237404247
> 
> And the answer's still the same: fix the vmware fusion emulation ...
> it's a software thing too.

It is already fixed in WS6.0, and I latest Fusion beta has fixed this as 
well.
							Petr


