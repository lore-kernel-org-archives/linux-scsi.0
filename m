From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 13:17:24 +0100
Message-ID: <1226060244.3997.7.camel@macbook.infradead.org>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>  <49143142.4010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49143142.4010809@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-11-07 at 07:14 -0500, Ric Wheeler wrote:
> I think that discard merging would be helpful (especially for devices 
> with more reasonable sized unmap chunks).

First we need generic fixes to the elevator code. It already notices
when you submit a request which _precisely_ matches an existing one in
both start and length, and will ensure that they happen in the right
order. But it _doesn't_ cope with requests that just happen to overlap.

It's on my TODO list; fairly near the top.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

