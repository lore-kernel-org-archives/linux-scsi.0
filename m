From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 18:22:06 +0200
Message-ID: <4BEC272E.10508@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org> <1273766778.4353.200.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273766778.4353.200.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

Hello,

On 05/13/2010 06:06 PM, James Bottomley wrote:
> I'm not sure this is such a good interface ... it sounds very error
> prone for what is effectively a binary lock/unlock.

Well, the original block interface was like that.  It has been used as
binary switch tho.  The requested capacity is always ~0ULL and return
value smaller than the current capacity is ignored.  I'm all for
dropping the capacity parameter and the return value from
->set_capacity() so that it just unlocks native capacity and directly
sets the new capacity.  Jens?

> Instead of just saying unlock the HPA and show me the new capacity
> (with a rescan), you have to echo the right number of sectors to the
> set_capacity variable.  Isn't a hpa_unlock libata specific attribute
> better (you could even call BLKRRPART from the user context of the
> write)?

Hmmm... I lost you.  What are you talking about?

Thanks.

-- 
tejun
