From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: Fri, 26 Sep 2003 09:03:36 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com>
References: <20030926102021.GA32502@chihiro.cern.ch> <m3k77vhghs.fsf@trained-monkey.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from filesrv1.system-techniques.com ([199.33.245.55]:53933 "EHLO
	filesrv1.baby-dragons.com") by vger.kernel.org with ESMTP
	id S262149AbTIZNDq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 09:03:46 -0400
In-Reply-To: <m3k77vhghs.fsf@trained-monkey.org>
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: KELEMEN Peter <Peter.Kelemen@cern.ch>, linux-scsi@vger.kernel.org

	Hello Jes & Peter ,

On Fri, 26 Sep 2003, Jes Sorensen wrote:
> >>>>> "Peter" == KELEMEN Peter <Peter.Kelemen@cern.ch> writes:
> Peter> [ Please Cc: me as I'm not subscribed to the list.  Thanks. ]
> Peter> Hello,
> Peter> Since 2.4.18, we have a problem with the above combo if and
> Peter> only if the transfer is odd number of bytes.  Even byte
> Peter> transfer works well.  The error message we see is:
> Peter,
> Have you tried using a different SCSI controller to see if it is
> driver related? Any chance you could try 2.4.21?
	If memory serves this is driver related .  And IIRC someone has
	made changes or at least put forth a patch to attempt to aleviate
	the odd byte count problem .  It is in (Again IIRC) both of the
	Symbois drivers (ie: 53c8xx.c & sym53c8xx_2) .  Do try a newer
	kernel than 2.4.21 tho 2.4.22 is what I am running .  Hth ,  JimL
-- 
       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+
