From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 01:32:25 -0800
Message-ID: <20181116093225.GA17033@infradead.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org>
 <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
 <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2018 at 11:17:29AM +0100, Paolo Bonzini wrote:
> > Well, that's what we have the security_file_ioctl() LSM hook for so that
> > your security model can arbitrate access to ioctls.
> 
> Doesn't that have TOC-TOU races by design?

If you want to look at the command - yes.  If you just want to filter
read vs write vs ioctl, no.

> Also, what about SG_IO giving write access to files that are only opened
> read-only (and only have read permissions)?

Allowing SG_IO on read-only permissions sounds like a reall bad idea,
filtering or not.
