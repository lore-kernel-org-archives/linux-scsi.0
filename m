From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/5] fc class: add fc host default default dev loss setting
Date: Mon, 09 Aug 2010 10:17:49 -0500
Message-ID: <4C601C1D.2020601@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu> <4C601681.3020807@emulex.com> <4C60180F.5030209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34894 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab0HIPTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2010 11:19:12 -0400
In-Reply-To: <4C60180F.5030209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "brking@us.ibm.com" <brking@us.ibm.com>

On 08/09/2010 10:00 AM, Mike Christie wrote:
> On 08/09/2010 09:53 AM, James Smart wrote:
>> Mike,
>>
>> why the motivation to get the dev_loss_tmo from the LLDD ? I would have
>> assumed this would have become a base fc_host attribute which is rd/wr,
>> the default coming from the module parameter, with the "set" propagating
>> to the LLDD to change all rports to the host value (either new direct
>> callback, or loop which calls rport set routine).
>
> qla2xxx and fnic set the default/initial dev_loss_tmo based on some
> value they get from firmware.
>

The qla2xxx mention is not right.

Andrew,

It looks like when the port_down_retry_count is set the 
login_retry_count could be adjusted. When the dev_loss_tmo is set by 
sysfs does qla2xxx, possibly want to adjust the login_retry_count?
