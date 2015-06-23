From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Tue, 23 Jun 2015 01:29:03 -0700
Message-ID: <1435048143.7460.50.camel@haakon3.risingtidesystems.com>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57272 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbFWI3F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 04:29:05 -0400
In-Reply-To: <5583C117.4030103@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Fri, 2015-06-19 at 09:13 +0200, Hannes Reinecke wrote:
> On 06/19/2015 08:48 AM, Christoph Hellwig wrote:
> > What's the benefit of the SAS transport class writeout?  I honestly
> > always saw tcm_loop as a simple loopback driver, with the different
> > transport IDs in the PR code as a gimmick.  Note that vhost and
> > xen-blkback copies that style and I did plan to consolidate it
> > in common code.
> > 
> The benefit is that tcm_loop will show up in the system as a 'real'
> SAS hba; long-term goal is to simulate SAS multipathing here.
> I was even planning on adding simlated FC infrastructure, too;
> with that we could simulate FC multipathing, too, and our QA would
> be _so_ happy...
> 

Sounds like a reasonable use-case to support for loopback testing.

> Again, these patches are mainly a collection of patches I've done to
> test various scenarios, in the hope others might find them useful,
> too. So I can easily hold off these patches until you've posted your
> rework.
> 

How different do you expect sas, fc, and iscsi transports to be..?

Do you think this would this be better served by a simple tcm_loop LLD
specific API for different multipath transports..?

