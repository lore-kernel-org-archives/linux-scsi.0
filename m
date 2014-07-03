From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Wed, 2 Jul 2014 23:05:06 -0700
Message-ID: <20140703060506.GA17456@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
 <20140628174609.930049472@linuxfoundation.org>
 <1404339330.1862.69.camel@ul30vt.home>
 <53B48B37.4000608@cs.wisc.edu>
 <1404341317.1862.71.camel@ul30vt.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404341317.1862.71.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 02, 2014 at 04:48:37PM -0600, Alex Williamson wrote:
> Thanks for the pointer.  It's curious why there was no objection to this
> going into stable if it's been known to be broken for a week.

I've never seen the stable patch on linux-scsi.  IMHO it should never
have been proposed for -stable with all the issues it caused.
