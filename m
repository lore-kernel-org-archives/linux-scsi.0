From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [dm-devel] SCSI's heuristics for enabling WRITE SAME still need
 work [was: dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 14:12:34 -0500
Message-ID: <5241E422.1010700@tributary.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net> <1379960325.4010.32.camel@localhost.localdomain> <52412581.2010909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.53]:41351 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXTMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 15:12:37 -0400
In-Reply-To: <52412581.2010909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "emilne@redhat.com" <emilne@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 9/24/2013 12:39 AM, Hannes Reinecke wrote:

> My drives support 'report opcodes', and report that write same is 
> supported: ... 93                 16    Write same(16) ...
> 
> but no support for page 'b0'. And yes, these are real SAS drives.

	So the question is, how many devices get the protect bit in the std inquiry
incorrect?

	If that is mostly correct, how about std inquiry (SPC>2), protect bit, and then
VPD page 0x86 (or alternatively then do the READ CAPACITY, P_TYPE instead of
page 0x86)?

	After all, the set of valid read/write opcodes is limited by the protection
mode format, yes?






	
