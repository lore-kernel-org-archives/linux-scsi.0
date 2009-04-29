From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
Date: Tue, 28 Apr 2009 20:33:46 -0700
Message-ID: <49F7CA9A.5000701@kernel.org>
References: <49F6678D.3080207@kernel.org> <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com> <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com> <49F7A71F.5040709@kernel.org> <20090429020331.GF21648@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:41696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZD2DfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 23:35:11 -0400
In-Reply-To: <20090429020331.GF21648@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Tue, Apr 28, 2009 at 06:02:23PM -0700, Yinghai Lu wrote:
>> dev_set_name(cdev, name);
>>
>> the name become fmt. 
> 
> Yes, and what happens if 'name' is '%s'?
> 

change
dev_set_name(cdev, name);
to
dev_set_name(cdev, "%s", name);

didn't fix the problem.

need to check name && name[0]

YH
