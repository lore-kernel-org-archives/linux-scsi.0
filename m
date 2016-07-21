From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 3/5] libata-scsi: fix overflow in mode page copy
Date: Thu, 21 Jul 2016 17:42:02 -0400
Message-ID: <20160721214202.GG23759@htj.duckdns.org>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
 <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
 <20160721211714.GE23759@htj.duckdns.org>
 <CAGnHSEkj2kXNUyQa=MxmLsTJT3P9xrQjpjoMLYiz6xKPB896EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEkj2kXNUyQa=MxmLsTJT3P9xrQjpjoMLYiz6xKPB896EA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:39:27AM +0800, Tom Yan wrote:
> Let me know how I should polish the description for this.

The above is because the signed ones are getting sign-extended making
them different from the unsigned ones which don't get padded in the
high bits.  Converting to u8 is the right thing to do but nothing here
is getting truncated.

Thanks.

-- 
tejun
