From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/15] qla4xxx: Added support for ISP82XX
Date: Sun, 13 Jun 2010 14:31:10 -0500
Message-ID: <4C1531FE.20103@cs.wisc.edu>
References: <20100611074656.GA27762@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42074 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0FMT25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2010 15:28:57 -0400
In-Reply-To: <20100611074656.GA27762@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, karen.higgins@qlogic.com

Patches 1-6 look good.

For this one I guess remove the extra scsi_block/unblock calls as 
discussed in the other thread and then remove the (void) casts in the 
qla4xxx_cmd_wait() calls.


On 06/11/2010 02:46 AM, Vikas Chaudhary wrote:
> +			(void) qla4xxx_cmd_wait(ha);

