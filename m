From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G)
 SAS cards
Date: Mon, 08 Jun 2009 19:30:23 +0400
Message-ID: <4A2D2E8F.6090207@vlnb.net>
References: <49E4B6D5.9060007@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:57500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbZFHPaR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 11:30:17 -0400
In-Reply-To: <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Foster_Brian@emc.com
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, ayan@marvell.com, James.Bottomley@HansenPartnership.com

Hi Brian,

Foster_Brian@emc.com, on 06/05/2009 10:10 PM wrote:
>> Hi All,
>>
>> I'm glad to announce that a target driver for Marvell 88SE64xx(3G) and
>> 88SE94xx(6G) SAS cards has been just added in the SCST SVN repository.
> A
>> lot of thanks to Marvell and Andy Yan!
>>
>> This driver allows to use a SAS controller based on Marvell 88SE64xx
> or
>> 88SE94xx chips as a SAN storage server (target). More info you can
> find
>> on the SCST page http://scst.sourceforge.net.
>>
>> You can download the driver from SCST SVN by running a command:
>>
>> $ svn co https://scst.svn.sourceforge.net/svnroot/scst
>>
> 
> Hi Vlad/Andy,
> 
> Is this target driver expected to work with 6320 cards as well? Using
> this driver, I was able to discover a SATA drive connected to the 6320
> in initiator mode. 
> 
> I connected the 6320 directly to a second 6320 on another machine, set
> up a virtual LUN with SCST (added to the default group, etc.) and
> enabled target mode, but I'm not seeing anything on the initiator side. 

Double check you don't have in the kernel log messages like "tgt_dev for 
LUN X not found, command to unexisting LU?" (I assume you have SCST 
tracing enabled, it is by default so in the SVN trunk/). If you do, then 
you didn't setup the virtual LUN correctly.

Vlad
