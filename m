From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: Controlling PATA access speeds
Date: Fri, 02 Jun 2006 16:10:54 -0500
Message-ID: <200606022110.k52LAsV7022096@falcon10.austin.ibm.com>
References: <BAY113-F20C5E81293FCD88D28597DDF910@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <BAY113-F20C5E81293FCD88D28597DDF910@phx.gbl> 
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 02 Jun 2006 15:37:51 CDT, "John Treubig" wrote:
>Because of my setup, I have had to pull pin 34 (PDIAG) high at the Promise 
>to make the Promise think I have a 40 pin cable.  At boot, the Promise 
>thinks I have a 40 wire cable installed and gives me a warning, yet when I 
>run my program that measures transfer rate in Linux, I still see the same 
>data rates as with an 80 wire cable (pin 34 shorted).  Is there any other 
>item that I'm missing besides having Pin 34 pulled high?  Does the drive's 
>echoing that it is UDMA5 capable have anything to do with it?  Is the fact 
>that I'm not carrying pin 34 all the way to the drive causing my problem?
>

What type of drive do you have?  A 2.5 laptop type?  26 meg/sec is 
about what you will see. :-/

++doug

