From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 13:50:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <770128112.1041108651@aslan.scsiguy.com>
References: <200212281500.gBSF0pc01929@localhost.localdomain>
 <712898112.1041103010@aslan.scsiguy.com> <3E0E071F.F6819548@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E0E071F.F6819548@digeo.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Rik van Riel <riel@conectiva.com.br>, Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

> "Justin T. Gibbs" wrote:
>> 
>> > So far, the only bug report I have is from Andrew Morton proving that
>> > it still  doesn't get it's bounce buffers right.
>> 
>> That hasn't applied since 6.2.10 or so.  2.5.X is still using 6.2.4.
>> 
> 
> 2.5.53 is using 6.2.24, and it is bounce buffering highmem I/O.  6.2.4
> was OK in this regard.

Hmm.  The only previous bug report I had in this area was related to a
missing cast.  That was fixed, but I guess it wasn't enough to solve
the problem.

--
Justin

