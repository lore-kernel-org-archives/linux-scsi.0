From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Thu, 3 Jul 2014 09:33:10 -0700
Message-ID: <20140703163310.GA21213@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
 <20140628174609.930049472@linuxfoundation.org>
 <1404339330.1862.69.camel@ul30vt.home>
 <53B48B37.4000608@cs.wisc.edu>
 <1404341555.16066.19.camel@dabdike>
 <20140703060548.GB17456@infradead.org>
 <1404395645.1949.2.camel@jarvis.lan>
 <20140703162748.GA24758@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140703162748.GA24758@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 03, 2014 at 09:27:48AM -0700, Greg Kroah-Hartman wrote:
> I copy everyone on the patch.  You were not on that patch as it doesn't
> look like it went through your tree at all.

It went through the target tree despite exclusive touching scsi
initiator side code.  I'm still not sure how this happened, but we
should take care to avoid this in the future.  In addition to this
regression due to a complete lack of testing it also caused various
merge issues.
