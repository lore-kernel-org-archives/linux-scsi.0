From: Luben Tuikov <luben@splentec.com>
Subject: Re: When must the io_request_lock be held?
Date: Thu, 08 Aug 2002 15:28:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D52C658.BEAFFA1D@splentec.com>
References: <200208071648.g77GmGH03563@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> 
> dledford@redhat.com said:
> > Again, if Marcello takes my patch, this will become easier as well
> > since  it adds a host->lock lock that allows you to get your driver
> > off the  horrible io_request_lock once and for all.  (Note: I may have
> > to change  the name to host->host_lock to make it match 2.5, but that
> > just annoys the  hell out of me because I *detest* totally redundant
> > names like that...)
> 
> Well, that's just semantics, I won't get into the argument...
> 

I've assumed that you also wanted to add that semantics are
quite _very_ important.

-- 
Luben
