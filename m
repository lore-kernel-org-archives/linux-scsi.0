From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Change signal used to exit scsi error handlers
Date: 09 Jan 2003 00:48:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1042073292.25607.2.camel@irongate.swansea.linux.org.uk>
References: <20030101210555.GS1378@linnie.riede.org>
	 <20030108225302.GE1378@linnie.riede.org>
	 <20030108233610.GH1112@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030108233610.GH1112@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Willem Riede <wrlk@riede.org>, linux-scsi@vger.kernel.org

On Wed, 2003-01-08 at 23:36, Mike Anderson wrote:
> The change looks reasonable to switch to another signal to avoid the
> problem. It is unclear why the comment mentioned only SIGPWR as the only
> alternative. It would think that SIGUSR1, SIGUSR2, etc. would also work
> maybe someone else on this list or linux-kernel would know why.

Pete Zaitcev figured it out - it also breaks other stuff. Seems to be a
bug caused by NPTL - looks like Daemonize() needs updating and has not
been.

