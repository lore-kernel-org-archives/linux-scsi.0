From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 01/10] qla4xxx: Do not wait for IO completion, after issuing
 stop_firmware
Date: Thu, 27 Mar 2014 18:06:43 -0700
Message-ID: <5334CB23.2010206@cs.wisc.edu>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com> <1393297625-928-2-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51398 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214AbaC1BGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 21:06:53 -0400
In-Reply-To: <1393297625-928-2-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

On 02/24/2014 07:06 PM, vikas.chaudhary@qlogic.com wrote:
> From: Tej Parkash <tej.parkash@qlogic.com>
> 
> Problem:
> iSCSI stop_firmware mailbox command is not completing outstanding IO.
> 


What about qla4xxx_hw_reset? I saw the comment in
qla4_8xxx_stop_firmware saying what you wrote above, but for the old
qla4xxx_isp_ops I did not see anything like that and it seems to use
different commands.
