From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/8] BNX2I: Added TCP timestamps option support
Date: Wed, 05 Jan 2011 14:52:17 -0600
Message-ID: <4D24DA01.9060709@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1294260267-17413-6-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40914 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1AEUzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:55:19 -0500
In-Reply-To: <1294260267-17413-6-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 01/05/2011 02:44 PM, Eddie Wai wrote:
> This TCP timestamps option is a module wise feature which can be
> enabled via the module param (time_stamps).  Once enabled, the TCP
> connection will advertise timestamps as an option to get negotiated.
>

Is there any reason this has to be module wide? Can the hw support 
having it per connection?
