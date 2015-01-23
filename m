From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 00/48] hpsa driver updates
Date: Fri, 23 Jan 2015 19:15:34 +0100
Message-ID: <54C28FC6.7040206@redhat.com>
References: <20150114215756.21325.41198.stgit@brunhilda> <20150123132138.GA4038@infradead.org> <07F70BBF6832E34FA1C923241E8833AB2DB13C4B@BBYEXM02.pmc-sierra.internal> <20150123170149.GA6333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbbAWSQG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 13:16:06 -0500
In-Reply-To: <20150123170149.GA6333@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brace <brace@pmcs.com>
Cc: Christoph Hellwig <hch@infradead.org>, Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/23/2015 06:01 PM, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 04:58:52PM +0000, brace wrote:
>> I made your requested changes. Do you want me to just send those up or the whole set up again?
>>
>> Tomas Henzl asked me to add a workqueue change also...

I have rebased the patch on top of your series and reposted an hour ago, you may use the new version.

> Just resend the whole series, looks like you're using git-end-email
> already.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

