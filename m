From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: SCSI trees, merges and git status
Date: Mon, 18 Apr 2005 20:04:56 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0504182003480.15725@ppc970.osdl.org>
References: <1113856118.4998.70.camel@mulgrave>  <Pine.LNX.4.58.0504181429570.15725@ppc970.osdl.org>
  <1113866092.4998.92.camel@mulgrave>  <Pine.LNX.4.58.0504181651241.15725@ppc970.osdl.org>
  <1113869594.4998.103.camel@mulgrave>  <Pine.LNX.4.58.0504181724170.15725@ppc970.osdl.org>
 <1113877071.4998.111.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <git-owner@vger.kernel.org>
In-Reply-To: <1113877071.4998.111.camel@mulgrave>
Sender: git-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: git@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Mon, 18 Apr 2005, James Bottomley wrote:
> 
> Fair enough.  If you pull from
> 
> rsync://www.parisc-linux.org/~jejb/scsi-misc-2.6.git

Thanks. Pulled and pushed out.

> Doing this exposed two bugs in your merge script:
> 
> 1) It doesn't like a completely new directory (the misc tree contains a
> new drivers/scsi/lpfc)
> 2) the merge testing logic is wrong.  You only want to exit 1 if the
> merge fails.

Applied.

		Linus
