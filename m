From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 1/5] fc class: add fc host default default dev loss setting
Date: Mon, 9 Aug 2010 10:53:53 -0400
Message-ID: <4C601681.3020807@emulex.com>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:50206 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756860Ab0HIOyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 10:54:25 -0400
In-Reply-To: <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "brking@us.ibm.com" <brking@us.ibm.com>

Mike,

why the motivation to get the dev_loss_tmo from the LLDD ?  I would have 
assumed this would have become a base fc_host attribute which is rd/wr, the 
default coming from the module parameter, with the "set" propagating to the 
LLDD to change all rports to the host value (either new direct callback, or 
loop which calls rport set routine).

- james s


michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch adds a fc_host setting to store the
> default dev_loss_tmo. It is used if the driver
> has a callack to get the value from the LLD. If
> the callback is not set, then we use the fc class
> module default value.
> 

