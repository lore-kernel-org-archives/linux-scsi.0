From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/10] qla4xxx: Added support for ISP82XX
Date: Mon, 12 Jul 2010 16:33:08 -0500
Message-ID: <4C3B8A14.4030803@cs.wisc.edu>
References: <20100710092048.GA11514@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42413 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab0GLV3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 17:29:53 -0400
In-Reply-To: <20100710092048.GA11514@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, karen.higgins@qlogic.com

On 07/10/2010 04:20 AM, Vikas Chaudhary wrote:
> @@ -622,18 +624,42 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
>   		default:
>   			DEBUG2(printk(KERN_WARNING
>   				      "scsi%ld: AEN %04x UNKNOWN\n",
> -				      ha->host_no, mbox_status));
> +				      ha->host_no, mbox_sts[0]));
>   			break;
>   		}
>   	} else {
>   		DEBUG2(printk("scsi%ld: Unknown mailbox status %08X\n",
>   			      ha->host_no, mbox_status));
>
> -		ha->mbox_status[0] = mbox_status;
> +		ha->mbox_status[0] = mbox_sts[0];
>   	}
>   }

Normally, if you resend your patchset you would just fix up these type 
of issues on the resend.

Other than the compile warning from that code, patches look fine. Thanks 
for fixing up the other stuff.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
