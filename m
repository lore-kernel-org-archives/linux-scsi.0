From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [BUG]  smartd crashing recent 2.6.32 kernel
Date: Fri, 19 Feb 2010 19:16:42 -0600
Message-ID: <4B7F37FA.2050608@gmail.com>
References: <1151832579@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1151832579@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Adding CCs. Looks like a megaraid_mbox bug..

On 02/19/2010 04:13 PM, devzero@web.de wrote:
> as time goes by, no real attempt or progress has been made to fix bug=
 #15171. ( http://bugzilla.kernel.org/show_bug.cgi?id=3D15171 )
>
> when smartd starts, the kernel crashes with this trace:
> https://bugzillafiles.novell.org/attachment.cgi?id=3D338427
>
> the machine with this problem will be go into production very soon, s=
o if anybody want`s to help on fixing this - we have a few days left...=
=2E..
> ______________________________________________________
> GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
> Jetzt freischalten unter http://movieflat.web.de
>
