From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Date: Tue, 29 Sep 2009 12:46:20 +0200
Message-ID: <20090929124620.2c8abc4d@infradead.org>
References: <20090929103353.GA11183@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZI2Kpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 06:45:55 -0400
In-Reply-To: <20090929103353.GA11183@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>

On Tue, 29 Sep 2009 12:33:53 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> This implements a minor cleanup of exported scsi headers,
> and adds export of headers that are de-facto used by userspace.
> The patches are on top of 2.6.32-rc1.
> Can these be queued for 2.6.32?
> Thanks.
> 

one of the problems I've found is that glibc has its own copy
of scsi headers, causing interesting conflicts. Do you know for
sure that with these cleanups we can retire the glibc headers?
(that would be very welcome)
If not, do you know what it would take to get to that point?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
