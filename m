From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problem with Gdt driver under smp?
Date: Mon, 4 Nov 2002 22:34:35 -0500
Sender: linux-smp-owner@vger.kernel.org
Message-ID: <20021105033435.GA16634@redhat.com>
References: <3DC0EBB3.9030707@holidaymarketing.com> <20021031120257.GF23217@redhat.com> <3DC71BF8.80100@holidaymarketing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-smp-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DC71BF8.80100@holidaymarketing.com>
To: Pedro Pla <pedropla@holidaymarketing.com>
Cc: linux-scsi@vger.kernel.org, linux-smp@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 09:16:40AM +0800, Pedro Pla wrote:
> Doug Ledford wrote:
> >
> >Sounds like typical bad RAM problems.  Run a memory test on your RAM.
> >
> > 
> >
> I've run memory tests, and memtest86 v3 gives no errors at all after its 
> most thorough testing, I did however find some problems when running a 
> test on memtest86 v2.8, however that gave errors on 8 seperate simm 
> cards running under two different dual p3 motherboards, I just find it 
> strange that they would all fail, I thought it might be the motherboard 
> then, but 2 motherboards failing?
> 

I've got a memory test shell script on my web site that runs under linux.  
Do me a favor and see if it thinks your machine has bad RAM.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
