From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Sun, 11 Jun 2006 19:18:08 +0800
Message-ID: <200606111918.08529.linux@highpoint-tech.com>
References: <200606111706.52930.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:4883 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP
	id S1750771AbWFKLDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jun 2006 07:03:52 -0400
In-Reply-To: <200606111706.52930.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sunday 11 June 2006 05:07 pm, HighPoint Linux Team wrote:
>>
>>	host->can_queue = le32_to_cpu(iop_config.max_requests);
>>	host->cmd_per_lun = le32_to_cpu(iop_config.max_requests);
>> 
>> You might want to think about adjusting this.  For the single LUN case,
>> it's fine.  For the multi-lun case it may allow commands to a single LUN
>> to starve everything else.
>
>There will be no multi-lun support for the controller so this is not
>an issue.

Sorry, a mistake. Multi-lun is supported.
Should host->can_queue be set to (cmd_per_lun * max_lun) ?

