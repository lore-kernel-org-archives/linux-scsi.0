From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: "scsi: use host wide tags by default" causes uas regression
Date: Wed, 9 Mar 2016 19:28:06 +0100
Message-ID: <56E06B36.4010204@redhat.com>
References: <56E06458.7040101@redhat.com>
 <20160309182603.GA29246@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933657AbcCIS2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2016 13:28:12 -0500
In-Reply-To: <20160309182603.GA29246@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>, funnybutton@mailinator.com

Hi,

On 09-03-16 19:26, Christoph Hellwig wrote:
> On Wed, Mar 09, 2016 at 06:58:48PM +0100, Hans de Goede wrote:
>> So my question is how do I tell the scsi layer to not submit more then X commands with
>> scsi_init_shared_tag_map() gone ?
>
> By setting ->can_queue in the Scsi_Host structure to the maximum number
> of command you want outstanding for this host.

Can I lower this after calling scsi_host_alloc(), or do I need to make
my template "dynamic" ?

Regards,

Hans

