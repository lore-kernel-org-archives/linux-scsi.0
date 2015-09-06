From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 0/1] Update scsi hosts to use idr for host number mgmt
Date: Sun, 6 Sep 2015 08:12:23 -0700
Message-ID: <55EC57D7.8040106@suse.com>
References: <cover.1441412268.git.lduncan@suse.com>
 <55EBEC12.9030904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59685 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750867AbbIFPMk (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Sun, 6 Sep 2015 11:12:40 -0400
In-Reply-To: <55EBEC12.9030904@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com

On 09/06/2015 12:32 AM, Sagi Grimberg wrote:
> On 9/5/2015 11:44 PM, Lee Duncan wrote:
>> This is an updated version of a patch I submitted a few days ago.
>>
>> The previous versions of this patch updated the scsi hosts module
>> to use the ida helper routines to allocate host numbers, instead
>> of using a simple integer.
>>
>> Based on a suggestion by Christoph Hellwig, I decided to use the
>> idr helper routines instead of the ida set, since the idr functions
>> can also associate a pointer with an index.
> 
> While we're at it, why not include sd index conversion?
> 

I'm not sure what you mean here.

Are you suggesting sd.c be updated to use idr index routines instead of
ida routines so that sd.c could associate instance pointers with
instance numbers, much like I did for hosts.c?

If so, looking over sd.c, I don't think that would be feasible. The sd.c
driver does not do any searches for a pointer based on the index number.
Could you be more specific?

And do you have any objections to this patch?
-- 
Lee Duncan

