From: Mark Lord <liml@rtr.ca>
Subject: Re: Controlling PATA access speeds
Date: Fri, 02 Jun 2006 18:33:06 -0400
Message-ID: <4480BCA2.1050707@rtr.ca>
References: <BAY113-F20C5E81293FCD88D28597DDF910@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY113-F20C5E81293FCD88D28597DDF910@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: dwm@austin.ibm.com, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

John Treubig wrote:
> Because of my setup, I have had to pull pin 34 (PDIAG) high at the 
> Promise to make the Promise think I have a 40 pin cable.  At boot, the 
> Promise thinks I have a 40 wire cable installed and gives me a warning, 
> yet when I run my program that measures transfer rate in Linux, I still 
> see the same data rates as with an 80 wire cable (pin 34 shorted). 

What data rate is that?  If it's less than 25MB/sec (or so),
then the udma mode won't make much of a difference either way.

Cheers
