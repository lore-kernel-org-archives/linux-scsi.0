From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Tue, 10 Jul 2018 23:45:42 -0700
Message-ID: <20180711064542.GA7377@infradead.org>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com>
 <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
 <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 10, 2018 at 05:53:18PM -0400, Tony Battersby wrote:
> At my job (https://www.cybernetics.com/), I use the write()/read()
> interface to the SCSI generic driver for access to tape drives and tape
> medium changers.  For example, the write()/read() interface is useful
> for implementing RAID-like functionality for tape drives since a single
> thread can send commands to multiple tape drives at once and poll() for
> command completion.  We have a lot of code invested in this interface,
> so it would be a huge pain for us if it were removed.  But in our case,
> everything runs as root (as the firmware of an embedded storage
> appliance), so extra permission checks should be OK.

Do you just use read/write on /dev/sg or also on /dev/bsg?  Because
I started a discussion to kill the read/write support for the latter
even before Linus brought it up here..  (and we have the same fix
pending for /dev/bsg)
