From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MD sets failing under heavy load in a DRBD/Pacemaker Cluster
Date: Tue, 04 Oct 2011 11:36:46 -0500
Message-ID: <1317746206.2994.152.camel@dabdike.int.hansenpartnership.com>
References: <CAKFseUPKzcEx94axosagf9wnMJfhr8TRvu3BUm4vDESj9Z_Dgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUPKzcEx94axosagf9wnMJfhr8TRvu3BUm4vDESj9Z_Dgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: General Linux-HA mailing list <linux-ha@lists.linux-ha.org>, linux-scsi@vger.kernel.org, drbd-user@lists.linbit.com, iscsitarget-devel@lists.sourceforge.net, "Support, Software" <support@lsi.com>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-04 at 14:01 +0200, Caspar Smit wrote:
> Oct  2 11:01:59 node03 kernel: [7370143.421999] mptbase: ioc0:
> LogInfo(0x31110b00): Originator={PL}, Code={Reset}, SubCode(0x0b00)
> cb_idx mptbase_reply
> Oct  2 11:01:59 node03 kernel: [7370143.435220] mptbase: ioc0:
> LogInfo(0x31181000): Originator={PL}, Code={IO Cancelled Due to
> Recieve Error}, SubCode(0x1000) cb_idx mptbase_reply
> Oct  2 11:01:59 node03 kernel: [7370143.442141] mptbase: ioc0:
> LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
> cb_idx mptbase_reply 

This indicates some type of hardware error in the LSI controller.  LSI
should be able to tell you what the error means.  My best guess (and it
is only a guess since I can't interpret the codes) is a link error, so
checking the SATA cables would be the first thing I'd do.

James


