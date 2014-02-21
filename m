From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Fri, 21 Feb 2014 11:57:30 -0500
Message-ID: <20140221165730.GA10929@htj.dyndns.org>
References: <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
 <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
 <20140221130614.GH6897@htj.dyndns.org>
 <5307849A.9050209@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5307849A.9050209@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yo,

On Fri, Feb 21, 2014 at 11:53:46AM -0500, Peter Hurley wrote:
> Ok, I can do that. But AFAIK it'll have to be an smp_rmb(); there is
> no mb__after unlock.

We do have smp_mb__after_unlock_lock().

> [ After thinking about it some, I don't think preventing speculative
>   writes before clearing PENDING if useful or necessary, so that's
>   why I'm suggesting only the rmb. ]

But smp_mb__after_unlock_lock() would be cheaper on most popular
archs, I think.

Thanks.

-- 
tejun
