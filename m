From: Steve Ralston <sjralston1@cox.net>
Subject: Re: An array failover driver
Date: Thu, 19 Dec 2002 16:24:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E024720.1030005@cox.net>
References: <EB1DF7EA0D32D611B79C0002A51363F194A7BE@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <yqi@lsil.com>
Cc: 'linux-scsi-reflector' <linux-scsi@vger.kernel.org>

On 12/19/2002 03:56 PM, Qi, Yanling wrote:

>Hi All, 
>
>I am going to develop a multiple-pathing driver to support our storage array
>hardware on Linux(2.4 and later). I prefer the driver sit on the top of HBA
>drivers (fibre channel adapter drivers) and below middle level (the unifying
>layer). In other words, insert my pseudo driver into middle level and lower
>level drivers. The driver will take care of path failover. I am still in
>research phase. Do you have any suggestions?
>  
>

I've been there & done that, for drivers/message/fusion drivers (aka for 
FC9x9 HABs).
The dynamic multi-pathing failover driver I wrote acted as sort of a shim,
sitting logically between the scsi midlayer and {mptbase+mptscsih} 
driver(s),
sort of exactly as you describe above.  The source is available via:
  ftp://ftp.lsil.com/pub/symchips/fibre_ch/Metastor/dmpath-2.01x25.tar.gz

Which HBA driver are you looking at doing this for?


