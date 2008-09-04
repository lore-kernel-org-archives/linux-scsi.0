From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 14/15] lpfc 8.2.8 : Add statistical reporting control
 and additional fc vendor events
Date: Thu, 4 Sep 2008 17:37:41 -0400
Message-ID: <48C05525.4050507@emulex.com>
References: <1219629035.7890.47.camel@localhost.localdomain> <1220564113.9767.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41238 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYIDVht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 17:37:49 -0400
In-Reply-To: <1220564113.9767.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ok - I'll pull your scsi-misc-2.6 tree tomorrow early am and recut the 
patches.

-- james s

James Bottomley wrote:
> On Sun, 2008-08-24 at 21:50 -0400, James Smart wrote:
>> Added support for new sysfs attributes: lpfc_stat_data_ctrl and
>> lpfc_max_scsicmpl_time. The attributes control statistical reporting
>> of io load.
>>
>> Added support for new fc vendor events for error reporting.
> 
> Had to drop this too ... it's giving a compile error because it's using
> a structure member introduced by 12/15
> 
> James
> 
> 
> 
