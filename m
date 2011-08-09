From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering problem
Date: Tue, 9 Aug 2011 15:09:54 -0500
Message-ID: <20110809200954.GH27723@beardog.cce.hp.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com> <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com> <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com> <1312920391.8648.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1312920391.8648.6.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Cameron <stephenmcameron@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 09, 2011 at 03:06:31PM -0500, James Bottomley wrote:
> On Tue, 2011-08-09 at 14:58 -0500, Stephen Cameron wrote:
> > On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
> > <stephenmcameron@gmail.com> wrote:
> > 
> > > Despite the above patch, which I do think is correct, I can still get
> > > a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)
> > 
> > Er, I meant 3.1-rc1, not 2.6.31-rc1.
> 
> Do I take it from the fact that you cc'd stable that you want these
> patches in the stable tree in spite of not adding the stable tag?
> 
> James
> 

Well, I obviously don't know how to CC stable properly.
I think I will stop since it only seems to annoy Greg
and make me feel like an idiot for trying.

-- steve
