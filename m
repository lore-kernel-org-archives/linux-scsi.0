From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v6 0/7] ZPODD patches
Date: Thu, 13 Sep 2012 16:15:18 +0800
Message-ID: <EA857C7C6FB245F1B2B3C82DEA6DA148@usish.com.cn>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <7AD76063A97F48128F7F6B285CD05C7E@usish.com.cn> <505150F7.3040800@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33361 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2IMIQN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2012 04:16:13 -0400
In-Reply-To: <505150F7.3040800@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Aaron Lu' <aaron.lu@intel.com>
Cc: 'Aaron Lu' <aaron.lwe@gmail.com>, 'Alan Stern' <stern@rowland.harvard.edu>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

> > For hard disk runtime power off, Is there (hardware?) requirement for
hard
> > drive to support similar feature?
> 
> No requirement for hard drive, as it does not need to remote wake up
> itself while powered off.
> 
> Please note that there is a v7 sent yesterday, you may want to take a
> look at that instead of v6.
> 
> And the runtime power off of hard drive is dropped from that patch set,
> I'll submit it in another patch set(pretty small changes needed).
> 
> Thanks,
> Aaron
[Jack Wang] Thanks Aaron for quick replay, for disk runtime power off, will
it   a different proach from block runtime power management patch set from
Lin Ming? 



