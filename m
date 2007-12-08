From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_wait_scan Kconfig option
Date: Sat, 08 Dec 2007 22:21:11 +0100
Message-ID: <475B0AC7.2030408@s5r6.in-berlin.de>
References: <20071207191242.71a9cc3e@linuxamd.linicks.net>	<475A9810.4070104@anagramm.de> <20071208162122.7e77601e@linuxamd.linicks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48074 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXLHVVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Dec 2007 16:21:22 -0500
In-Reply-To: <20071208162122.7e77601e@linuxamd.linicks.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Warne <nick@ukfsn.org>
Cc: Clemens Koller <clemens.koller@anagramm.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

> Clemens Koller <clemens.koller@anagramm.de> wrote:
>> Nick Warne schrieb:
>>> I am bringing this up again - primarily as I forgot about it after
>>> patching my build tree ages ago:
>>>
>>> http://lkml.org/lkml/2007/10/27/68

>> Please see the patch I sent some days ago, which does the very
>> same thing: http://marc.info/?l=linux-kernel&m=119677244318528&w=2

Besides, in order for scsi_wait_scan to work, drivers need to support it
explicitly, don't they?  If so, simply kill the "default m" from config
SCSI_WAIT_SCAN and let any driver which is integrated with it select it.

(Not that I'm a friend of select, but here is a case where it won't hurt
too much.)
-- 
Stefan Richter
-=====-=-=== ==-- -=---
http://arcgraph.de/sr/
