From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: [patch] 2.4.23-pre8: link error with both megaraid drivers
Date: Fri, 24 Oct 2003 05:27:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F989C0B.9040309@wanadoo.es>
References: <3F97F35D.30101@wanadoo.es> <20031023195223.GI11807@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Adrian Bunk wrote:

> On Thu, Oct 23, 2003 at 05:27:25PM +0200, Xose Vazquez Perez wrote:

>> IMO this patch makes a better job. It only allows one in kernel,
>> and it allows two modules at same time.

> My patch allows this, too, or what did I miss?

Nothing. But your patch adds too much complex code to do a single thing ;-)

> The difference between your and my patch is that your patch doesn't 
> allow one in kernel plus the other one modular.

Yes. And IMO there is not need to build a module when you get
the other statically inside the kernel. I can not imagine what will happen
if one is statically inside the kernel and someone try to load a module :-)

--
HTML mails are going to trash automatically
