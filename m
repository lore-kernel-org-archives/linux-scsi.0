From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: Re: Aic7xxx 6.2.28 and Aic79xx 1.3.0 Released
Date: Thu, 23 Jan 2003 14:14:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200301231215.h0NCEws23149@Port.imtp.ilyichevsk.odessa.ua>
References: <87730000.1043275833@aslan.btc.adaptec.com>
Reply-To: vda@port.imtp.ilyichevsk.odessa.ua
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <87730000.1043275833@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@btc.adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 23 January 2003 00:50, Justin T. Gibbs wrote:
> GNU patch relative to 2.5.59:
> 
> http://people.FreeBSD.org/~gibbs/linux/SRC/aic79xx-linux-2.5.59-20030
>122-gnupatch.gz

I didn't track your development efforts too closely...
does this mean that latest 2.4 (2.4.20?) will detect my oldie 7782?

On 24 October 2002 15:45, Denis Vlasenko wrote:
> > > The problem is that it does not see its disks when I boot Linux.
> > > Currently I'm running it in NFS root mode, but 16MB RAM is not
> > > much fun without swap :(
> > >
> > > I'd like to stick printks here and there in driver source,
> > > thought you may have some advice.
> >
> > Since you seem to have enabled the EISA/VLB probe in your config,
> > I don't know why your controller is not probed.
>
> I sticked some printks in the code, here is a new syslog output
> (diff with printks is at the end).
--
vda
