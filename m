From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: netlink: avoid including netlink interface in scsi
 module
Date: Thu, 19 May 2011 14:09:57 -0500
Message-ID: <4DD56B05.8040004@cs.wisc.edu>
References: <1305753940-18570-1-git-send-email-jengelh@medozas.de> <20110518174857.77dbda09.randy.dunlap@oracle.com> <alpine.LNX.2.01.1105192105140.8008@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39793 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab1ESTKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 15:10:13 -0400
In-Reply-To: <alpine.LNX.2.01.1105192105140.8008@frira.zrqbmnf.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 05/19/2011 02:06 PM, Jan Engelhardt wrote:
> On Thursday 2011-05-19 02:48, Randy Dunlap wrote:
>
>> On Wed, 18 May 2011 23:25:39 +0200 Jan Engelhardt wrote:
>>
>>> Only scsi_transport_fc needs it, so don't include it in scsi_mod
>>> if fc=m.
>>
>> BTW, scsi_transport_iscsi.c also makes netlink calls (but it's missing the
>> needed header files).
>
> What, where?
>

iscsi uses netlink directly. It does not use scsi_netlink helpers/lib 
code yet.
