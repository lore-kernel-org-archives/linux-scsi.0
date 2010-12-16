From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
Date: Thu, 16 Dec 2010 19:04:29 +0100
Message-ID: <4D0A54AD.90400@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <20101216170030.GA13585@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101216170030.GA13585@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Hey, Christoph.

On 12/16/2010 06:00 PM, Christoph Hellwig wrote:
> Any chance could could conver all block drivers to the new methods
> instead of leaving us with yet another incomplete transition?

Yeah, sure.  I wanted to make sure the approach is agreed on before
going forward with the rest of changes.  It's not like we have a lot
of .media_changed in the kernel anyway.  The only problem is that some
drivers are quite obscure at this point and would be pretty difficult
to verify, but then again if nobody can noticie the breakage, maybe
it's not broken at all.  Once things settle down, I'll go ahead with
the rest of the conversion.

Thanks.

-- 
tejun
