From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 08 Jul 2009 09:06:18 -0700
Message-ID: <1247069178.5973.6.camel@desktop>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
	 <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	 <1247063244.4159.40.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760133AbZGHQJA@vger.kernel.org>
In-Reply-To: <1247063244.4159.40.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
> 
> You might also try this patch from martin petersen:  it will print out
> the actual command that's causing the problems ... that might give a
> clue.
> 
> James

On the bugzilla entry ,

http://bugzilla.kernel.org/show_bug.cgi?id=13727

Thomas Meyer indicated it was (possibly) the following commit,

018e0446890661504783f92388ecce7138c1566d

I added Jens to the CC ..

Daniel
