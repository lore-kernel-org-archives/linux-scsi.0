From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 14/36] scsi_dh_alua: separate out alua_stpg()
Date: Fri, 2 Oct 2015 08:03:53 -0700
Message-ID: <560E9CD9.5020607@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-15-git-send-email-hare@suse.de>
 <560DCAA6.1020404@sandisk.com> <560E1EE6.7090609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:33566
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752040AbbJBPEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 11:04:01 -0400
In-Reply-To: <560E1EE6.7090609@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/01/2015 11:06 PM, Hannes Reinecke wrote:
> On 10/02/2015 02:07 AM, Bart Van Assche wrote:
>> The old implementation calls the callback function 'fn' if the flag
>> TPGS_MODE_EXPLICIT has not been set but the new implementation not.
>> Please mention this in the patch description if this behavior change
>> is intentional.
>>
> Actually, this looks more like an error with the old implementation.
> 'fn' is the callback signalling that the failover command has been
> completed, and the caller (in most case dm-multipath) relies on 'fn'
> to be executed for further processing.
> So 'fn' should be executed, irrespective of the TPGS_MODE_EXPLICIT flag.

Thank you for the feedback. I think reviewers would be grateful if this 
change would be documented in the patch description.

Bart.
