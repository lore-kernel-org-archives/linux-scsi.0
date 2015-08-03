From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 3 Aug 2015 12:50:33 -0400
Message-ID: <20150803165033.GA24594@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
 <20150803151826.GG32599@mtj.duckdns.org>
 <1438616563.2173.16.camel@HansenPartnership.com>
 <20150803155513.GI32599@mtj.duckdns.org>
 <1438620246.2173.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438620246.2173.20.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On Mon, Aug 03, 2015 at 09:44:06AM -0700, James Bottomley wrote:
> I'm not arguing that *this* patch is the best way to do it.  You asked
> *why* autosense and that's what I answered.  I think there's time to

Heh, that was mostly me being confused.  I was thinking NCQ autosense
was the only way ATA devices would report sense data.

> work out the implementation details to get them to be correct and well
> structured.

Yeah, definitely.

Thanks.

-- 
tejun
